# frozen_string_literal: true

module StanfordCore
  # A base class to be inherited by all classes that wrap Java Stanford CoreNLP
  # binded objects
  class NlpWrapper
    attr_reader :nlp_proxy

    # @param nlp_proxy a Java Stanford CoreNlp binded object
    def initialize(nlp_proxy)
      @nlp_proxy = nlp_proxy
    end

    # sends a method call to the Java binding
    # @param [Symbol, String] method the method name to be called
    def send_nlp(method, *arguments, &block)
      nlp_proxy.send(:method_missing, method, *arguments, &block)
    end

    # gets an annotation from the java binding. Usually used to get other
    # Java CoreNlp bindings
    # @param [Symbol, String] annotation the annotation to be gotten
    def get_annotation(annotation)
      nlp_proxy.get(annotation)
    end

    def to_s
      nlp_proxy.to_s
    end

    def iterable_method_to_array(iterable_method, wrapper_class = nil, *arguments)
      list = []
      send_nlp(iterable_method, *arguments).each do |item|
        if wrapper_class.present?
          list.push(wrapper_class.new(item))
        else
          list.push(item)
        end
      end
      list
    end
  end
end
