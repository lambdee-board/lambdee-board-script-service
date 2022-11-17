# rubocop:disable Naming/PredicateName
# frozen_string_literal: true

module DB
  module QueryAPI
    # Provides methods for defining methods
    # which fetch appropriate associated records.
    module Associations
      # @return [ActiveSupport::HashWithIndifferentAccess]
      def relations
        @relations ||= ::ActiveSupport::HashWithIndifferentAccess.new
      end
      alias associations relations

      # @return [Array<Symbol>]
      def relation_names
        @relations.map { |key, _val| key.to_sym }
      end
      alias association_names relation_names

      # @return [Array<Class>]
      def associated_classes
        @relations.map { |_key, val| val.target_class }
      end
      alias related_classes associated_classes

      # @param name [Symbol] Name of the relation
      # @param klass [Class] Class of the related object
      # @param foreign_key [Symbol, nil] Name of the foreign key field.
      # @return [void]
      def has_many(name, klass, foreign_key: nil, through: nil)
        foreign_key ||= "#{table_name.to_s.delete_suffix('s')}_id"
        return has_many_through(name, klass, through:, foreign_key:) if through

        relations[name] = Relation::OneToMany.new(name, base_class: self, target_class: klass, foreign_key: "#{::DB.table_name(klass)}.#{foreign_key}")
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
        relations[name] = Relation::OneToOne.new(name, base_class: self, target_class: klass, foreign_key: "#{::DB.table_name(klass)}.#{foreign_key}")
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
      # @param one_to_one [Boolean] Whether it's a one to one relation instead of many to one.
      # @return [void]
      def belongs_to(name, klass, foreign_key: :"#{name}_id", one_to_one: false)
        attribute foreign_key, ::Shale::Type::Integer

        relation_class = one_to_one ? Relation::OneToOne : Relation::ManyToOne
        relations[name] = relation_class.new(name, base_class: self, target_class: klass, foreign_key: "#{table_name}.#{foreign_key}")
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
        relations[name] = Relation::ManyToMany.new(name, base_class: self, target_class: klass, foreign_key: "#{through}.#{foreign_key}", through:)
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
