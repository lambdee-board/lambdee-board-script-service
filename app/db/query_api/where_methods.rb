# frozen_string_literal: true

module DB
  module QueryAPI
    # Provides methods which manipulate the content
    # of the `WHERE` clause in the database query.
    #
    # Requires `#where_query` and `#where_query=` to be defined.
    module WhereMethods
      # @param kwargs [Hash]
      # @return [self]
      def where(**kwargs)
        self.where_query ||= {}
        return WhereProxy.new(self) if kwargs.empty?

        where_query.merge! and: kwargs

        self
      end

      def and(**kwargs, &)
        logical_operator(:and, **kwargs, &)
      end

      def or(**kwargs, &)
        logical_operator(:or, **kwargs, &)
      end

      private

      # @param name [Symbol] Name of the logical operator
      # @param kwargs [Hash{Symbol => Object}]
      # @param block [Proc, nil]
      def logical_operator(name, **kwargs, &block)
        raise "Can't use `#{name}` without `where`." unless where_query
        raise ::ArgumentError, 'Arguments or block must be provided' unless kwargs.any? || !block.nil?
        raise ::ArgumentError, 'Either arguments or a block should be present, not both!' if kwargs.any? && !block.nil?

        new_operator_body = kwargs.any? ? kwargs : AndOrContext.new.tap { _1.instance_eval(&block) }.body
        operator_body = where_query[name] || where_query
        self.where_query = { name => operator_body.merge(new_operator_body) }

        self
      end
    end
  end
end
