module Apify
  class Patterns

    EMAIL = /\A[a-z0-9\+\-_\.]+@[a-z0-9]+[a-z0-9\-\.]*[a-z0-9]+\z/i
    URL = /(http|https):\/\/[\w\-_]+(\.[\w\-_]+)*([\w\-\.,@?^=%&amp;:\/~\+#]*[\w\-\@?^=%&amp;\/~\+#])?/
    SQL_DATE = /\A\d{4}-\d{2}-\d{2}\z/
    SQL_DATETIME = /\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\z/

  end
end