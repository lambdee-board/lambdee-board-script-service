# rubocop:disable Naming/PredicateName
# frozen_string_literal: true

module DB
  module QueryAPI
    # Provides methods for defining methods
    # which fetch appropriate associated records.
    module Associations
      # @param name [Symbol] Name of the relation
      # @param klass [Class] Class of the related object
      # @param foreign_key [Symbol, nil] Name of the foreign key field.
      # @return [void]
      def has_many(name, klass, foreign_key: nil, through: nil)
        foreign_key ||= "#{table_name.to_s.delete_suffix('s')}_id"
        return has_many_through(name, klass, through:, foreign_key:) if through

        relation_methods_module.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}
            #{klass}.where(#{foreign_key}: id)
          end
        RUBY
      end

      # @param name [Symbol] Name of the relation
      # @param klass [Class] Class of the related object
      # @param foreign_key [Symbol, nil] Name of the foreign key field.
      # @return [void]
      def has_one(name, klass, foreign_key: nil)
        foreign_key ||= "#{table_name.to_s.delete_suffix('s')}_id"
        relation_methods_module.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}
            @#{name} ||= #{klass}.find_by(#{foreign_key}: id)
          end

          def #{name}=(val)
            raise ::ArgumentError, "#{name.inspect} should be a `#{klass}` but was a `\#{val.class}` (\#{val.inspect})" unless val.is_a?(#{klass})

            @#{name} = val
            val.#{foreign_key} = id
          end
        RUBY
      end

      # @param name [Symbol] Name of the relation
      # @param klass [Class] Class of the related object
      # @param foreign_key [Symbol] Name of the foreign key field.
      # @return [void]
      def belongs_to(name, klass, foreign_key: :"#{name}_id")
        attribute foreign_key, ::Shale::Type::Integer

        relation_methods_module.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{foreign_key}=(val)
            super(val)
            @#{name} = nil
          end

          def #{name}
            @#{name} ||= #{klass}.find(#{foreign_key}).tap { self.#{foreign_key} = _1.id }
          end

          def #{name}=(val)
            raise ::ArgumentError, "#{name.inspect} should be a `#{klass}` but was a `\#{val.class}` (\#{val.inspect})" unless val.is_a?(#{klass})

            @#{name} = val
            self.#{foreign_key} = val.id
          end
        RUBY
      end

      private

      # @return [void]
      def has_many_through(name, klass, through:, foreign_key:)
        relation_methods_module.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}
            #{klass}.join(:#{through}).where('#{through}.#{foreign_key}': id)
          end
        RUBY
      end

      # @return [Module]
      def relation_methods_module
        @relation_methods_module ||= ::Module.new.tap { include _1 }
      end
    end
  end
end

# rubocop:enable Naming/PredicateName
