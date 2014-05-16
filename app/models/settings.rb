class Settings < Settingslogic
  source "#{Rails.root}/config/constants.yml"
  namespace Rails.env
  load!
end
