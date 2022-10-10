# rubocop:disable Naming/PredicateName
# frozen_string_literal: true

module DB
  module QueryAPI
    # Provides methods for defining methods
    # which fetch appropriate associated records.
    module Associations
      # @param name [Symbol] Name of the relation
      # @param klass [Class] Class of the related object
      # @param foreign_key [Symbol] Name of the foreign key field.
      # @return [void]
      def has_many(name, klass, foreign_key:)
        relation_methods_module.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}
            @#{name} ||= #{klass}.where(#{foreign_key}: id).load
          end
        RUBY
      end

      # @param name [Symbol] Name of the relation
      # @param klass [Class] Class of the related object
      # @param foreign_key [Symbol] Name of the foreign key field.
      # @return [void]
      def has_one(name, klass, foreign_key:)
        relation_methods_module.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}
            @#{name} ||= #{klass}.find_by(#{foreign_key}: id)
          end

          def #{name}=(val)
            raise ::ArgumentError, "#{name.inspect} should be a `#{klass}` but was a `\#{val.class}` (\#{val.inspect})" unless val.is_a?(#{klass})

            @#{name} = val
          end
        RUBY
      end

      # @param name [Symbol] Name of the relation
      # @param klass [Class] Class of the related object
      # @param foreign_key [Symbol] Name of the foreign key field.
      # @return [void]
      def belongs_to(name, klass, foreign_key:)
        relation_methods_module.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}
            @#{name} ||= #{klass}.find(#{foreign_key})
          end

          def #{name}=(val)
            raise ::ArgumentError, "#{name.inspect} should be a `#{klass}` but was a `\#{val.class}` (\#{val.inspect})" unless val.is_a?(#{klass})

            @#{name} = val
          end
        RUBY
      end

      private

      # @return [Module]
      def relation_methods_module
        @relation_methods_module ||= ::Module.new.tap { include _1 }
      end
    end
  end
end

# rubocop:enable Naming/PredicateName
