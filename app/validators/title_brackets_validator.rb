class TitleBracketsValidator < ActiveModel::Validator
  OPENING_BRACKETS = %w[( \[ {].freeze
  CLOSING_BRACKETS = %w[) \] }].freeze

  def validate(record)
    record.errors.add(:title, :invalid) unless balanced_brackets?(record.title)
  end

  private

  def balanced_brackets?(title, empty_brackets = false, *bracket_stack)
    title.each_char do |char|
      closing_bracket_index = CLOSING_BRACKETS.index char

      if closing_bracket_index
        next if pop_from_stack(bracket_stack, closing_bracket_index, empty_brackets)
        return false
      end

      empty_brackets = add_to_stack(bracket_stack, char)
    end

    bracket_stack.blank?
  end

  def add_to_stack(stack, char)
    return false if OPENING_BRACKETS.exclude? char

    stack << char
    true
  end

  def pop_from_stack(stack, closing_bracket_index, empty_bracket)
    return false unless find_opening_bracket(closing_bracket_index) == stack.last && !empty_bracket

    return true if stack.pop
    false
  end

  def find_opening_bracket(closing_bracket_index)
    OPENING_BRACKETS[closing_bracket_index]
  end
end
