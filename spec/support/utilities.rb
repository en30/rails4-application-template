def sign_in(options = {})
  user = options[:as] || FactoryGirl.create(:user)
  login_as user, scope: :user, run_callbacks: false
end

def handle_js_confirm(accept=true)
  if Capybara.current_driver == :selenium_chrome
    if accept
      page.driver.browser.switch_to.alert.accept
    else
      page.driver.browser.switch_to.alert.dismiss
    end
  else
    begin
      page.evaluate_script "window.original_confirm_function = window.confirm"
      page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
      yield
    ensure
      page.evaluate_script "window.confirm = window.original_confirm_function"
    end
  end
end

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    loop until finished_all_ajax_requests?
  end
end

def finished_all_ajax_requests?
  page.evaluate_script('jQuery.active').zero?
end
