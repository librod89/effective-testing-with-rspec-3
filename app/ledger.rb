require_relative '../config/sequel'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
      message = nil

      if !expense.key?('payee')
        message = 'Invalid expense: `payee` is required'
      elsif !expense.key?('amount')
        message = 'Invalid expense: `amount` is required'
      elsif !expense.key?('date')
        message = 'Invalid expense: `date` is required'
      end

      return RecordResult.new(false, nil, message) if message

      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end
  end
end
