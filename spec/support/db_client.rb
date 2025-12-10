require 'pg'

class DBClient
  def self.connection
    @connection ||= PG.connect(
      host: 'localhost',
      port: 5432,
      dbname: 'ticket_flow_production',
      user: 'app_user',
      password: 'app_password'
    )
  end

  def self.query(sql)
    connection.exec(sql)
  end
end
# frozen_string_literal: true

