module LicenseFinder
  module CLI
    class Base < Thor
      def self.auditable
        method_option :who, desc: "The person making this decision"
        method_option :why, desc: "The reason for making this decision"
      end

      no_commands do
        def decisions
          @decisions ||= Decisions.saved!(LicenseFinder.config.artifacts.decisions_file)
        end
      end

      private

      def say_each(coll)
        if coll.any?
          coll.each do |item|
            say(block_given? ? yield(item) : item)
          end
        else
          say '(none)'
        end
      end

      def txn
        @txn ||= {
          who: options[:who],
          why: options[:why],
          when: Time.now.getutc
        }
      end

      def modifying
        yield
        decisions.save!
      end
    end
  end
end

