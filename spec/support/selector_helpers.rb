module Support
  module SelectorHelpers
  module_function

    def row_of(el)
      el.find(:xpath, "ancestor::tr")
    end
  end
end
