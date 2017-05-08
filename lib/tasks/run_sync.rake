require "selenium-webdriver"
require 'yaml'
require 'ruby-progressbar'
require 'faker'
require 'uuid'
require 'fileutils'

namespace :apoc do
    desc "Sync up apoc"
    task :sync, [:message] => :environment do |task, args|
        @driver = Selenium::WebDriver.for :chrome
        apoc_bot
        @driver.quit
    end
end

def apoc_bot
    @driver.get "https://aws.state.ak.us/ApocReports/CampaignDisclosure/CDIncome.aspx"
    sleep(1)
    date_field = @driver.find_element(:id, "M_C_sCDTransactions_csfFilter_txtBeginDate")
    date_field.send_keys ('1/1/2012')
    date_field = @driver.find_element(:id, "M_C_sCDTransactions_csfFilter_txtEndDate")
    date_field.send_keys Time.now.strftime("%m/%d/%Y")
    @driver.find_element(:id, 'M_C_sCDTransactions_csfFilter_btnSearch').click
    sleep(5)
    @driver.find_element(:id, 'M_C_sCDTransactions_csfFilter_btnExport').click
    sleep(5)
    @driver.navigate.to "https://aws.state.ak.us/ApocReports/CampaignDisclosure/CDIncome.aspx?exportAll=True&exportFormat=CSV&isExport=True"
    sleep(360)
end
