require_relative '../support/db_client'
RSpec.describe 'Database Validation' do
  let(:db_client) { DBClient }
  it "check ticket exists" do
    result = db_client.query("SELECT * FROM tickets WHERE id = 1;")
    puts(result.to_a)
    expect(result.ntuples).to be > 0
    TestLogger.info 'Ticket validated'
  end
end
 