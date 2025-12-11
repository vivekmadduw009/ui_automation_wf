# spec/support/logger.rb
require 'logger'
require 'fileutils'
require 'allure-rspec'

module TestLogger
  COLORS = {
    step:  "\e[36m", # cyan
    info:  "\e[32m", # green
    warn:  "\e[33m", # yellow
    error: "\e[31m", # red
    reset: "\e[0m"
  }

  # Small helper to write to multiple IOs simultaneously
  class MultiIO
    def initialize(*targets)
      @targets = targets
    end

    def write(*args)
      @targets.each { |t| t.write(*args) }
    end

    def close
      @targets.each { |t| t.close unless t.closed? }
    end

    def flush
      @targets.each { |t| t.flush if t.respond_to?(:flush) }
    end
  end

  class << self
    def logs_dir
      @logs_dir ||= File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'logs'))
    end

    def ensure_logs_dir
      FileUtils.mkdir_p(logs_dir) unless Dir.exist?(logs_dir)
    end

    def log_file_paths
      ensure_logs_dir

      Dir.glob(File.join(logs_dir, '*')).each do |path|
        begin
          FileUtils.rm_rf(path)
        rescue StandardError => e
          puts "Failed to remove old log file or directory #{path}: #{e.message}"
        end
      end
      timestamp = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
      timestamped = File.join(logs_dir, "test-#{timestamp}.log")
      latest = File.join(logs_dir, "test.log") # always overwritten (latest)
      [timestamped, latest]
    end
    # return a logger instance that writes to both timestamped file and latest file
    def logger
      return @logger if defined?(@logger) && @logger

      timestamped_path, latest_path = log_file_paths

      # Open files: timestamped in append (just created), latest truncated (overwrite per run)
      ts_io = File.open(timestamped_path, 'a')
      latest_io = File.open(latest_path, 'w') # truncate to start fresh each run

      # Ensure immediate flush
      ts_io.sync = true
      latest_io.sync = true

      multi_io = MultiIO.new(ts_io, latest_io)

      @logger = Logger.new(multi_io)
      @logger.level = Logger::DEBUG   # capture debug/info/warn/error
      @logger.formatter = proc do |severity, datetime, _, msg|
        "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}\n"
      end

      @logger.instance_variable_set(:@__multi_io_handles, [ts_io, latest_io])

      @logger
    end

    def format_console(severity, message)
      timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      color = COLORS[severity] || COLORS[:info]
      "#{color}[#{timestamp}] #{severity.to_s.upcase}: #{message}#{COLORS[:reset]}"
    end

    # ------------------ LOG METHODS ---------------------

    def step(message)
      logger.info("STEP: #{message}")
      puts format_console(:step, message)

      # Allure step + lightweight attachment
      begin
        Allure.step(name: message) do
          Allure.add_attachment(
            name: "Step: #{message}",
            source: message,
            type: Allure::ContentType::TXT
          )
          yield if block_given?
        end
      rescue StandardError => e
        logger.error("Allure.step failed: #{e.message}")
      end
    end

    def info(message)
      logger.info(message)
      puts format_console(:info, message)
      safe_allure_attach("Info", message)
    end

    def debug(message)
      logger.debug(message)
      puts format_console(:info, message) # you can change color if desired
      safe_allure_attach("Debug", message)
    end

    def warn(message)
      logger.warn(message)
      puts format_console(:warn, message)
      safe_allure_attach("Warning", message)
    end

    def error(message)
      logger.error(message)
      puts format_console(:error, message)
      safe_allure_attach("Error", message)
    end

    private

    def safe_allure_attach(name, message)
      Allure.add_attachment(
        name: name,
        source: message,
        type: Allure::ContentType::TXT
      )
    rescue StandardError => e
      logger.error("Allure.add_attachment failed: #{e.message}")
    end
  end
end