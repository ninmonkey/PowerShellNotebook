Import-Module $PSScriptRoot\..\PowerShellNotebook.psd1 -Force

Describe "Test Invoke Execute Notebook" -Tag 'Invoke-ExecuteNotebook' {

    It "Should have Invoke-ExecuteNotebook" {
        $actual = Get-Command Invoke-ExecuteNotebook -ErrorAction SilentlyContinue
        $actual | Should -Not -Be  $Null
    }

    It "tests $Parameters takes a hashtable" {
        Invoke-ExecuteNotebook -Parmeters @{b = 2 }
    }

    It "tests $Parameters takes a an ordered hashtable" {
        Invoke-ExecuteNotebook -Parmeters ([ordered]@{ a = 1 })
    }

    It "Tests just passing in a noteboook " {
        $InputNotebook = "$PSScriptRoot\NotebooksForUseWithInvokeOutfile\parameters.ipynb"        
        
        $actual = Invoke-ExecuteNotebook -InputNotebook $InputNotebook

        $actual[0].Trim() | Should -BeExactly 'alpha = 1.2, ratio = 3.7, and alpha * ratio = 4.44'
        $actual[1].Trim() | Should -BeExactly 'a = 1 and twice = 2'
    }

    # It "Should have these results from the Invoke-PowerShellNotebook" {
    #     $actual = Invoke-PowerShellNotebook "$PSScriptRoot\GoodNotebooks\testPSNb1.ipynb"

    #     $actual | Should -Not -Be  $Null

    #     $actual.Count | Should -Be 2

    #     $actual[0] | Should -Be 20
    #     $actual[1] | Should -Be 11
    # }

    # It "Should have these results from the testPSExcel.ipynb" {
    #     $actual = Invoke-PowerShellNotebook "$PSScriptRoot\GoodNotebooks\testPSExcel.ipynb"
    
    #     $actual.Count | Should -Be 3

    #     # # Returns results from get-service
    #     # $propertyNames = $actual[0][0].psobject.Properties.name
    #     # $propertyNames[0] | Should -Be 'Status'
    #     # $propertyNames[1] | Should -Be 'Name'
    #     # $propertyNames[2] | Should -Be 'DisplayName'

    #     # Returns results from get-process
    #     $propertyNames = $actual[1][0].psobject.Properties.name
    #     $propertyNames[0] | Should -Be 'Company'
    #     $propertyNames[1] | Should -Be 'Name'
    #     $propertyNames[2] | Should -Be 'Handles'

    #     # Returns results from an array
    #     $actual[2].Count | Should -Be 10
    # }

    # It "Should create and Excel file" {
    #     $actual = Invoke-PowerShellNotebook "$PSScriptRoot\GoodNotebooks\testPSExcel.ipynb" -AsExcel

    #     $actualPath = Split-Path $actual
    #     $expectedPath = $pwd.path

    #     $actualPath | Should -Be $expectedPath

    #     $actualExcelFileName = Split-Path $actual -Leaf
    #     $expectedExcelFileName = "testPSExcel.xlsx"

    #     $actualExcelFileName | Should -Be $expectedExcelFileName

    #     Remove-Item $actual #-ErrorAction SilentlyContinue
    # }

    # It "Should export to an Excel file to cwd from the testPSExcel.ipynb" {
    #     $actual = Invoke-PowerShellNotebook "$PSScriptRoot\GoodNotebooks\testPSExcel.ipynb" -AsExcel
    #     # $actual | Should -Be "$PSScriptRoot\testPSExcel.xlsx"
    #     $actualExcelFileName = Split-Path $actual -Leaf
    #     $expectedExcelFileName = "testPSExcel.xlsx"
    #     $actualExcelFileName | Should -Be $expectedExcelFileName

    #     $sheets = Get-ExcelSheetInfo $actual

    #     $sheets.Count | Should -Be 2

    #     $sheets[0].Name | Should -Be 'Sheet1'
    #     $sheets[1].Name | Should -Be 'Sheet2'


    #     Remove-Item $actual -ErrorAction SilentlyContinue
    # }

    # It "Should read and execute a single code block" {
    #     $actual = @(Invoke-PowerShellNotebook "$PSScriptRoot\GoodNotebooks\SingleCodeBlock.ipynb")

    #     $actual.Count | Should -Be 1

    #     $record = $actual[0]
    #     $record[0].Region | Should -BeExactly "South"
    #     $record[0].Item | Should -BeExactly "lime"
    #     $record[0].TotalSold | Should -Be 20

    #     $record[1].Region | Should -BeExactly "West"
    #     $record[1].Item | Should -BeExactly "melon"
    #     $record[1].TotalSold | Should -Be 76
    # }

    # It "Should read and execute a code block stored as a string" {
    #     $actual = @(Invoke-PowerShellNotebook "$PSScriptRoot\MultiLineSourceNotebooks\MultiLineSourceAsString.ipynb")

    #     $actual[0][0] | Should -Be 1
    #     $actual[0][9] | Should -Be 10
    # }

    # It "Should throw if -Outfile specifies a file that already exists" {
    #     $srcNoteBook = "$PSScriptRoot\NotebooksForUseWithInvokeOutfile\testFile1.ipynb"
    #     $fullName = "TestDrive:\alreadyExists.ipynb"
       
    #     "" | Set-Content $fullName
        
    #     { Invoke-PowerShellNotebook -NoteBookFullName $srcNoteBook -Outfile $fullName } | Should -Throw "$fullName already exists"
    #     Remove-Item $fullName -ErrorAction SilentlyContinue        
    # }

    # It "Should create the new -Outfile" {
    #     $srcNoteBook = "$PSScriptRoot\NotebooksForUseWithInvokeOutfile\testFile1.ipynb"
    #     $fullName = "TestDrive:\newNotebook.ipynb"

    #     Invoke-PowerShellNotebook -NoteBookFullName $srcNoteBook -Outfile $fullName 
    #     Test-Path $fullName | Should -Be $true
    #     Remove-Item $fullName -ErrorAction SilentlyContinue        
    # }

    # It "Should create the new -Outfile with correct content" {
    #     $srcNoteBook = "$PSScriptRoot\NotebooksForUseWithInvokeOutfile\testFile1.ipynb"
    #     $fullName = "TestDrive:\newNotebook.ipynb"

    #     Invoke-PowerShellNotebook -NoteBookFullName $srcNoteBook -Outfile $fullName

    #     $notebookJson = Get-Content $fullName | ConvertFrom-Json
        
    #     $codeCells = @($notebookJson.cells | Where-Object { $_.'cell_type' -eq 'code' })

    #     $codeCells.Count | Should -Be 1
    #     $codeCells.cell_type | Should -BeExactly "code"
    #     $codeCells.outputs.name | Should -BeExactly "stdout"
    #     $codeCells.outputs.output_type | Should -BeExactly "stream"
        
    #     $codeCells.outputs.text | Should -BeExactly ("Hello World" + [System.Environment]::NewLine)
    # }

    # It "Should work with variables across cells" {
    #     $srcNoteBook = "$PSScriptRoot\NotebooksForUseWithInvokeOutfile\VariablesAcrossCells.ipynb"
    #     $fullName = "TestDrive:\NewVariablesAcrossCells.ipynb"

    #     Invoke-PowerShellNotebook -NoteBookFullName $srcNoteBook -Outfile $fullName
    #     Test-Path $fullName | Should -Be $true

    #     $notebookJson = Get-Content $fullName | ConvertFrom-Json
        
    #     $codeCells = @($notebookJson.cells | Where-Object { $_.'cell_type' -eq 'code' })

    #     $codeCells.Count | Should -Be 2

    #     $targetCell = $codeCells[0]
    #     $targetCell.cell_type | Should -BeExactly "code"
    #     $targetCell.outputs.name | Should -BeExactly "stdout"
    #     $targetCell.outputs.output_type | Should -BeExactly "stream"
    #     $targetCell.outputs.text | Should -BeNullOrEmpty

    #     $targetCell = $codeCells[1]
    #     $targetCell.cell_type | Should -BeExactly "code"
    #     $targetCell.outputs.name | Should -BeExactly "stdout"
    #     $targetCell.outputs.output_type | Should -BeExactly "stream"
    #     $targetCell.outputs.text | Should -Be 6
    # }

    # It "Should handle a cell with errors" {
    #     $srcNoteBook = "$PSScriptRoot\NotebooksForUseWithInvokeOutfile\CellHasAnError.ipynb"
    #     $fullName = "TestDrive:\NewCellHasAnError.ipynb"

    #     Invoke-PowerShellNotebook -NoteBookFullName $srcNoteBook -Outfile $fullName
 
    #     $notebookJson = Get-Content $fullName | ConvertFrom-Json
    #     $codeCells = @($notebookJson.cells | Where-Object { $_.'cell_type' -eq 'code' })
    #     $codeCells.Count | Should -Be 1

    #     $targetCell = $codeCells[0]
    #     $targetCell.cell_type | Should -BeExactly "code"
    #     $targetCell.outputs.name | Should -BeExactly "stdout"
    #     $targetCell.outputs.output_type | Should -BeExactly "stream"
    #     $targetCell.outputs.text | Should -Not -BeNullOrEmpty
    # }

    # It "Should handle a cell with errors and cells that work" {
    #     $srcNoteBook = "$PSScriptRoot\NotebooksForUseWithInvokeOutfile\ComboGoodAndErrorCells.ipynb"
    #     $fullName = "TestDrive:\NewComboGoodAndErrorCells.ipynb"

    #     Invoke-PowerShellNotebook -NoteBookFullName $srcNoteBook -Outfile $fullName
 
    #     $notebookJson = Get-Content $fullName | ConvertFrom-Json
    #     $codeCells = @($notebookJson.cells | Where-Object { $_.'cell_type' -eq 'code' })
    #     $codeCells.Count | Should -Be 3

    #     $targetCell = $codeCells[0]
    #     $targetCell.cell_type | Should -BeExactly "code"
    #     $targetCell.outputs.name | Should -BeExactly "stdout"
    #     $targetCell.outputs.output_type | Should -BeExactly "stream"
    #     $targetCell.outputs.text | Should -Be 20

    #     $targetCell = $codeCells[1]
    #     $targetCell.cell_type | Should -BeExactly "code"
    #     $targetCell.outputs.name | Should -BeExactly "stdout"
    #     $targetCell.outputs.output_type | Should -BeExactly "stream"
    #     $targetCell.outputs.text | Should -Not -BeNullOrEmpty

    #     $targetCell = $codeCells[2]
    #     $targetCell.cell_type | Should -BeExactly "code"
    #     $targetCell.outputs.name | Should -BeExactly "stdout"
    #     $targetCell.outputs.output_type | Should -BeExactly "stream"
    #     $targetCell.outputs.text | Should -Be 42
    # }
}