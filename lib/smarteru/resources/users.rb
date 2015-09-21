module Smarteru
  module Resources
    class Users < Base
      def get(id_or_email)
        params = { user: normalize_id_param(id_or_email) }

        response = client.request('getUser', params)

        return response
      rescue Error => e
        return nil if e.code == 'GU:03'
        fail e
      end

      def create(info = {})
        validate!(info, :email, :employee_i_d, :given_name, :surname, :group)

        params = create_params(info)

        client.request('createUser', params)
      end

      def update(id_or_email, info = {})
        params = { user:
          { identifier: normalize_id_param(id_or_email),
            info:       info,
            profile:    nil,
            groups:     nil } }

        client.request('updateUser', params)
      end

      def update_employee_id(id_or_email, new_employee_id)
        update(id_or_email, employee_i_d: new_employee_id)
      end

      def signin(id_or_email)
        params = { security: normalize_id_param(id_or_email) }

        client.request('requestExternalAuthorization', params)
      end

      def enroll(id_or_email, group, module_id)
        params = {
          learning_module_enrollment: {
            enrollment: {
              user:                normalize_id_param(id_or_email),
              group_name:          group,
              learning_module_i_d: module_id } } }

        client.request('enrollLearningModules', params)
      end

      def learner_report(id_or_email, group)
        params = {
          report: {
            filters: {
              groups: {
                group_names: {
                  group_name: group } },
              learning_modules: nil,
              users: {
                user_identifier: normalize_id_param(id_or_email, :email_address) } },
            columns: [
              { column_name: 'ENROLLED_DATE' },
              { column_name: 'COMPLETED_DATE' },
              { column_name: 'DUE_DATE' },
              { column_name: 'LAST_ACCESSED_DATE' },
              { column_name: 'STARTED_DATE' } ],
            custom_fields: nil } }

        response = client.request('getLearnerReport', params)
        [ response.result[:learner_report][:learner] ].flatten.compact
      end

      def enrolled?(id_or_email, group, course_name)
        enrollments = learner_report(id_or_email, group)
        enrollments.any? { |e| e[:course_name] == course_name }
      end

      private

      DEFAULT_CREATE_INFO = {
          learner_notifications:    1,
          supervisor_notifications: 0,
          send_email_to:            'Self' }

      def create_params(info)
        group = info.delete(:group)

        { user: {
            info:    info.merge(DEFAULT_CREATE_INFO),
            profile: { home_group: group },
            groups: {
              group: {
                group_name:        group,
                group_permissions: nil } } } }
      end

      def normalize_id_param(value, email_field_name = :email)
        value =~ /@/ ? { email_field_name => value } : { employee_i_d: value }
      end

      def validate!(params, *args)
        args.each do |arg|
          fail(":#{arg} required to create user") unless params.include?(arg)
        end
      end
    end
  end
end