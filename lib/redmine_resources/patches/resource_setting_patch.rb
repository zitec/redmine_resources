module RedmineResources
  module Patches
    module ResourceSettingPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          has_many :resource_setting, as: :setting_object, dependent: :destroy
        end
      end

      module InstanceMethods
        def can_edit_resources(project)
          self.resource_setting.editable(project).count > 0
        end

        def can_view_resources(project)
          self.resource_setting.visible(project).count > 0
        end

      end
    end
  end
end

[Tracker, Role].each do |base|
  unless base.included_modules.include? RedmineResources::Patches::ResourceSettingPatch
    base.send(:include, RedmineResources::Patches::ResourceSettingPatch)
  end
end