# frozen_string_literal: true

from "only_imported_by_another_import", import { OnlyImportedByAnotherImport }

class OnlyImportsOnlyImportedByAnotherImport
  def self.syntax_error; en#d
end
