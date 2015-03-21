json.loans @loans do |json, loan|
  json.partial! 'loans/loan', loan: loan
end
