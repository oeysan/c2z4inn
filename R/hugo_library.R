# Set working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
Sys.setenv(LANG = "EN")
rm(list=ls())
graphics.off()
source("backend.R")

# Post to Zotero library
library <- LibraryPost(
  lang = "no", 
  locale = "nn-NO", 
  start.date = "2017-01",
  end.date = "2024-04",
  update = TRUE,
  post = TRUE,
  post.only = TRUE
)

# Update pages
lib.no <- LibraryUpdate("no")
lib.en <- LibraryUpdate("en")

# Render README
RenderSave(
  "README.Rmd", 
  output.format = "github_document",
  keep.yaml = FALSE,
  remove.blank = FALSE
)

commit.name <- "0.1.0"
branch.name <- "main"

init <- system("git init")
origin <- system("git remote add origin git@github.com:oeysan/c2z4inn.git")
add.files <- system("git add *")
add.files <- system("git add .")
commit.files <- system(sprintf("git commit -m \"%s\"", commit.name))
branch <- system(sprintf("git branch -M %s", branch.name))
push <- system(sprintf("git push -u origin %s", branch.name))
