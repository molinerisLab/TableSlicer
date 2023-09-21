# TableSlicer
A very simple shiny app that slice a data table in many different tables, one for each provided list of row identifiers

![image](https://github.com/molinerisLab/TableSlicer/assets/5821630/a51d7f55-4728-4c03-9d68-d74fe0f10a12)

## Input

### Data table
A tab delimited file, eventually gzipped (`.gz` estension) having feature on rows and samples on columns.

In the case of gene expression: genes on rows and samples on columns.

The first column must contain a row identifier (gene name).

### Feature lists
A excel file having lists of feature identifiers (gene names), one list in each column.
The first row must be an header to name the lists.

## Output

A excel file having a sheet for each list in the input excel file.

Each sheet si a subset of the original data matrix.
