# Set working directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
rm(list=ls())
graphics.off()
source("backend.R")

start.date <- "2017-01"
end.date <- "2025-04"
unit.id = "209.0.0.0"

# Post to Zotero library
library <- LibraryPost(
  unit.id = unit.id,
  start.date = start.date,
  end.date = end.date,
  update = TRUE,
  post = TRUE,
  post.only = TRUE
)


# Update pages
lib.no <- LibraryUpdate(unit.id, "nn")
lib.en <- LibraryUpdate(unit.id, "en")

# Render README
RenderSave(
  "README.Rmd", 
  md.name = "README",
  output.format = "github_document",
  keep.yaml = FALSE,
  remove.blank = FALSE
)

commit.name <- "0.2.3-250401"
branch.name <- "main"

init <- system("git init")
origin <- system("git remote add origin git@github.com:oeysan/c2z4inn.git")
add.files <- system("git add *")
add.files <- system("git add .")
commit.files <- system(sprintf("git commit -m \"%s\"", commit.name))
branch <- system(sprintf("git branch -M %s", branch.name))
push <- system(sprintf("git push -u origin %s", branch.name))
