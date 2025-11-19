# Ruby UI Automation Framework

A lightweight and modular **UI automation framework** built using:

* **Ruby**
* **RSpec**
* **Capybara**
* **Selenium / ChromeDriver**
* **Page Object Model (POM)**
* **Allure Reporting**
* **YAML-based test data**

This framework is ideal for testing web applications with clear separation of concerns and easily maintainable test cases.

---

## 📁 Project Structure

```
project
│   .env                  # Environment variables (optional)
│   .rspec                # RSpec settings
│   .solargraph.yml       # Editor intellisense config
│   Gemfile               # Ruby dependencies
│   README.md
│
├── .idea/                # IDE config (ignored in git)
│
├── config/
│       test_data.yml     # Test data for the framework
│
├── logs/
│       test.log          # Runtime logs
│       test-<timestamp>.log
│
├── reports/
│   └── allure-results/   # Allure raw results (auto-generated)
│
└── spec/
    │   spec_helper.rb     # RSpec configuration
    │
    ├── features/
    │       login_spec.rb  # Example UI feature tests
    │
    ├── pages/             # Page Object Model (POM)
    │       base_page.rb
    │       dashboard_page.rb
    │
    └── support/
            capybara.rb    # Capybara driver setup
            helpers.rb     # Utility methods
            logger.rb      # Custom logger
```

---

## 🚀 Getting Started

### **1. Install Ruby**

Install Ruby 3.x or above.

Check Ruby version:

```bash
ruby -v
```

---

### **2. Install bundler**

```bash
gem install bundler
```

---

### **3. Install dependencies**

```bash
bundle install
```

---

## ▶️ Running the Tests

### **Run all tests**

```bash
rspec
```

### **Run a specific spec**

```bash
rspec spec/features/login_spec.rb
```

### **Run with documentation format**

```bash
rspec --format documentation
```

---

## 📊 Reports

### **Allure Reporting**

#### Generate Allure results:

Results are automatically stored at:

```
reports/allure-results/
```

#### Generate HTML report:

```bash
allure generate reports/allure-results --clean
```

#### Open the report:

```bash
allure open allure-report
```

---

## ⚙️ Configuration

### **Test Data (`config/test_data.yml`):**

Use YAML to store:

* Login credentials
* URLs
* Test inputs

Example:

```yml
login:
  username: testuser
  password: password123
```

---

## 🧱 Framework Components

### **1. Page Objects (`/spec/pages`)**

Defines reusable UI elements and methods.
Example: `dashboard_page.rb`.

### **2. Support Files (`/spec/support`)**

* `capybara.rb` → Browser setup
* `helpers.rb` → Utility functions
* `logger.rb` → Custom framework logger

### **3. Features (`/spec/features`)**

RSpec feature test scripts.

---

## 🧪 Example Test (login_spec.rb)

```ruby
RSpec.describe 'Login Feature' do
  it 'logs in successfully' do
    visit '/'
    fill_in 'username', with: 'testuser'
    fill_in 'password', with: 'password123'
    click_button 'Login'
    expect(page).to have_content('Dashboard')
  end
end
```

---

## 📦 Dependencies (Gemfile)

Key libraries used:

* `rspec`
* `capybara`
* `selenium-webdriver`
* `allure-rspec`
* `dotenv` (optional)
* `faker` (optional)

Run:

```bash
bundle install
```

---

## 🤝 Contributing

1. Create a new branch
2. Commit your changes
3. Push and submit a Pull Request

---

## ✨ Author

**Vivek Varma Maddu**
QA Lead | Automation Engineer

---
