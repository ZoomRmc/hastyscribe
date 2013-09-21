import os, parseopt, strutils, markdown

# Source
const src_css = "assets/hastyscribe.css".slurp

proc style_tag(css): string =
  result = "<style>$1</style>" % [css]

let css = src_css.style_tag

### MAIN

var opt = initOptParser()

opt.next

if opt.kind != cmdArgument:
  quit()

# Input file name
let input_file = opt.key
let inputsplit = input_file.splitFile

# Output file name
let output_file = inputsplit.dir/inputsplit.name & ".htm"

let source = input_file.readFile

# Document Variables
let body = source.md(MKD_DOTOC or MKD_EXTRA_FOOTNOTE)

let document = """<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  $css
</head> 
<body>
  <div class="pure-g-r">
    <div class="pure-u">
$body
    </div>
  </div>
</body>""" % ["css", css, "body", body]

output_file.writeFile(document)
