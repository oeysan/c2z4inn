# Import packages
library("c2z")
library("c2z4uni")
library("htmltools")

library("dplyr")
library("xml2")
library("stringr")
library("future")
library("future.apply")
library("progressr")


# Define proejct dir (i.e., outside R folder)
setwd(normalizePath(file.path(getwd(), "..")))
# Define local.storage
local.storage <- file.path(getwd(), "storage")
# Define R folder
r.folder <- file.path(getwd(), "R")
# Define Units folder
unit.data <- file.path(r.folder, "units")
# Define content
content <- file.path(getwd(), "content")
# Path to nn publications
pub.nn <- file.path(content, "nn", "pub")
# Path to en publications
pub.en <- file.path(content, "en", "pub")
# Define pub rmd
pub.file <- file.path(r.folder, "pub.Rmd")
# Define headless Rmd
headless <- file.path(r.folder, "headless.Rmd")
# Define about.nn Rmd
about.nn <- file.path(r.folder, "about_nn.Rmd")
# Define about.en Rmd
about.en <- file.path(r.folder, "about_en.Rmd")
# Define stats_nn Rmd
stats.nn <- file.path(r.folder, "stats_nn.Rmd")
# Define stats_en Rmd
stats.en <- file.path(r.folder, "stats_en.Rmd")
# Define stats menu Rmd
stats.menu <- file.path(r.folder, "stats_menu.Rmd")
# Define zotero
zotero <- c2z::Zotero(
  user = FALSE,
  token = "ZOTERO_INN",
  token.api = "ZOTERO_INN_API"
)

################################################################################
###############################Internal Data####################################
################################################################################

#' @title MountData
#' @keywords internal
#' @noRd
MountData <- function(lang, sdg.data = NULL, silent = TRUE) {
  
  # Load sdg.data and sdg.predictions if not provided
  if (is.null(sdg.data)) {
    sdg.data <- c2z4uni:::LocalStorage(
      "sdg_predictions_summary", 
      local.storage,
      message = "Loading SDG Summaries",
      silent = silent
    )
  }
  
  items <- c2z4uni:::LocalStorage(
    "items", 
    local.storage,
    message = "Loading items",
    silent = silent
  )
  
  bibliography <- c2z4uni:::LocalStorage(
    "bibliography", 
    local.storage,
    message = "Loading bibliographies",
    lang = lang,
    silent = silent
  )
  
  monthlies <- c2z4uni:::LocalStorage(
    "monthlies", 
    local.storage,
    message = "Loading monthlies",
    lang = lang,
    silent = silent
  )
  
  unit.paths <- c2z4uni:::LocalStorage(
    "unit_paths", 
    local.storage,
    message = "Loading unit paths",
    lang = lang,
    silent = silent
  )
  
  if (any(nrow(unit.paths))) {
    unit.paths <- unit.paths |>
      dplyr::left_join(
        dplyr::select(unit.names, id, acronym),
        by = "id"
      )
  }
  
  extras <- c2z4uni:::LocalStorage(
    "monthlies_extras", 
    local.storage,
    message = "Loading extras",
    silent = silent
  )
  
  updated_keys <- c2z4uni:::LocalStorage(
    "updated_keys", 
    local.storage,
    message = "Loading updated keys",
    lang = lang,
    silent = silent
  )
  
  cristin.monthly <- list(
    unit.paths = unit.paths,
    monthlies = monthlies
  )
  
  # Finally, assign all variables to the parent frame
  assign("sdg.data", sdg.data, envir = parent.frame())
  assign("items", items, envir = parent.frame())
  assign("bibliography", bibliography, envir = parent.frame())
  assign("unit.paths", unit.paths, envir = parent.frame())
  assign("monthlies", monthlies, envir = parent.frame())
  assign("extras", extras, envir = parent.frame())
  assign("cristin.monthly", cristin.monthly, envir = parent.frame())
  assign("updated.keys", updated_keys, envir = parent.frame())
}

unit.names <- readr::read_csv(
  file.path(unit.data, "units.csv"),
  show_col_types = FALSE
)

################################################################################
###############################Internal Functions###############################
################################################################################

#' @title Dict
#' @keywords internal
#' @noRd
i18n.nn <- jsonlite::fromJSON(
  file.path(r.folder, "i18n", "nn.json"), 
)
assign("nn", i18n.nn, envir = c2z4uni:::.dictEnv)
i18n.en <- jsonlite::fromJSON(
  file.path(r.folder, "i18n", "en.json"), 
)
assign("en", i18n.en, envir = c2z4uni:::.dictEnv)
Dict <- c2z4uni:::Dict

#' @title SdgSum
#' @keywords internal
#' @noRd
SdgSum <- \(x, 
            data, 
            sdg.data,
            split = NULL, 
            total = FALSE,
            average = FALSE) {
  
  # Visible bindings
  sdg.sum <- n.publications <- names <- NULL
  
  unit.data <- data |>
    dplyr::filter(grepl(x, collections)) |>
    dplyr::arrange(year.month) |>
    list()
  
  years <- sort(unique(unit.data[[1]]$year))
  
  if (!is.null(split)) {
    names <- names(table(unit.data[[1]][, split]))
    unit.data <- unit.data[[1]] |>
      dplyr::group_split(!!ensym(split))
  }
  
  year.months <- unlist(lapply(years, \(x) sum(grepl(x, names))))
  
  if (any(nrow(sdg.data$sdgs))) { 
    sdg.sum <- lapply(unit.data, \(x) {
      sum.data <- sdg.data$sdgs |> 
        dplyr::semi_join(x, by = "key") |>
        dplyr::summarise(
          dplyr::across(dplyr::starts_with("sdg"), 
                        ~sum(.x, na.rm = TRUE)
          )
        )
      if (total) sum.data <- sum(sum.data)
      return (sum.data)
    })
    if (total) sdg.sum <- unlist(sdg.sum)
  }
  
  
  if (is.list(sdg.sum) & length(sdg.sum) == 1) {
    sdg.sum <- unlist(sdg.sum)
  }
  
  n.publications <- unlist(lapply(unit.data, nrow))
  
  if (average) {
    names <- years
    grouping <- rep(1:length(year.months), times = year.months)
    sdg.sum <- unlist(lapply(split(sdg.sum, grouping), mean))
    n.publications <- unlist(lapply(split(n.publications, grouping), mean))
  }
  
  return.list <- list(
    sdg.sum = sdg.sum,
    n.publications = n.publications,
    names = names
  )
  
  return (return.list)
}

#' @title Stats
#' @keywords internal
#' @noRd
Stats <- \(unit = NULL, 
           unit.paths, 
           items, 
           monthlies, 
           extras, 
           sdg.data,
           lang = "nn",
           render = TRUE,
           units.only = FALSE,
           min = 30,
           max.level = 2) {
  
  unit <- unit.paths |>
    dplyr::filter(id == unit | acronym == unit | name == unit | key == unit)
  
  if (!any(nrow(unit))) {
    return (NULL)
  }
  
  data <- items |>
    dplyr::left_join(monthlies, by = "key", suffix = c("", ".remove")) |>
    dplyr::left_join(extras, by = "key", suffix = c("", ".remove")) |>
    dplyr::select(-c(dplyr::ends_with(".remove"))) |>
    dplyr::filter(grepl(unit$key, collections))
  
  if (!c2z4uni:::GoFish(min < nrow(data) , FALSE)) {
    return (NULL)
  }
  
  sdg.unit <- sdg.data$sdgs |>
    dplyr::filter(key %in% data$key)
  
  sdg.unit.sum <- sdg.unit |>
    dplyr::summarise(
      dplyr::across(
        dplyr::starts_with("sdg"), sum
      )
    )
  
  sdg.data <- list(
    sdgs = sdg.unit,
    sum = sdg.unit.sum
  )
  
  if (!any(nrow(sdg.unit))) {
    return (NULL)
  }
  
  sdg.overview <- SdgOverview(
    lang = lang, 
    sdg.data = sdg.data, 
    render = FALSE, 
    archive.append = paste0("&collection=", unit$key), 
    sort = TRUE, 
    delete = TRUE,
    header = FALSE,
    silent = TRUE
  ) 
  
  unit.name <- unit$name
  archive.url <- paste0(
    "{{< params subfolder >}}", 
    lang, 
    "/archive/?",
    paste0("&collection=", unit$key)
  )
  n.publications <- nrow(data)
  n.sdg <- sum(sdg.data$sum)
  
  publication.trend <- PublicationTrend(
    SdgSum(unit$key, data, sdg.data, "year.month", TRUE, TRUE),
    lang
  )
  
  sdg.doughnut <- SdgDoughnut(
    lang, 
    sdg.data,
    FALSE, 
    FALSE,
    div.width = "550px",
    div.height = "500px",
    silent = TRUE
  )
  
  # Only use publication.trend on level less than max level
  ## Default is 2, meaning institutions (e.g., INN) and faculties.
  if (unit$level > max.level) {
    publication.trend <- NULL
  }
  
  params <- list(
    unit.name = unit.name,
    archive.url = archive.url,
    n.publications = n.publications,
    n.sdg = n.sdg,
    sdg.overview = sdg.overview,
    publication.trend = publication.trend,
    sdg.doughnut = sdg.doughnut
  )
  
  path <- unit.paths |>
    dplyr::filter(key %in% unit$paths[[1]]) |>
    dplyr::pull(acronym) |>
    (\(x) do.call(file.path, as.list(c("stats", x))))() 
  
  if (units.only) {
    return.list <- unit
  } else {
    return.list <- list(
      unit = unit,
      path = path,
      params = params
    )
  }
  
  if (!render) {
    return (return.list)
  }
  
  stats.file <- if (lang == "nn") stats.nn else stats.en
  
  RenderSave(
    stats.file,
    params = params,
    md.dir = file.path(
      content, 
      lang, 
      dirname(path)
    ),
    md.name = basename(path)
  )
  
  return (return.list)
}

#' @title CreateStats
#' @keywords internal
#' @noRd
CreateStats <- \(lang = "nn", sdg.data = NULL, silent = FALSE) {
  
  # Mount Data
  MountData(lang, sdg.data)
  
  start.message <- sprintf(
    "Creating descriptive statistics for %s.",
    c2z4uni:::Numerus(
      nrow(unit.paths),
      "unit",
    )
  )
  
  stats.data <- c2z::ProcessData(
    data = unit.paths,
    func = \(data) {
      Stats(
        unit = data$id,
        unit.paths = unit.paths, 
        items = items, 
        monthlies = monthlies, 
        extras = extras, 
        sdg.data = sdg.data,
        lang = lang,
        render = TRUE,
        units.only = TRUE
      )
    },
    by.rows = TRUE,
    use.multisession = TRUE,
    process.message = "name",
    start.message = start.message,
    handler = "cli",
    silent = silent
  )

  stats.units <- stats.data$results
  tree <- as.character(NestedList(stats.units, lang = lang))
  tree.select <- SelectBox(stats.units, lang = lang)

  RenderSave(
    stats.menu,
    params = list(tree = tree, tree.select = tree.select),
    md.dir = file.path(content, lang, "headless"),
    md.name = "stats"
  )
  
}

#' @title SelectBox
#' @keywords internal
#' @noRd
SelectBox <- \(data,
               folder = "stats", 
               subfolder = "{{< params subfolder >}}",
               id = "tree-select",
               lang = "nn") {
  
  
  options <- lapply(seq_len(nrow(data)), \(i) {
    x <- data[i,] 
    path <- data |>
      dplyr::filter(key %in% x$paths[[1]]) |>
      dplyr::pull(acronym) |>
      (\(x) do.call(
        file.path, 
        as.list(c(paste0(subfolder, lang), folder, x)))
      )()
    sprintf("<option value=\"%s\">%s</option>", path, x$name)
  })
  
  options <- c(
    sprintf("<option value=\"\">%s</option>", Dict("selection", lang)),
    c2z:::ToString(options, "\n")
  )
  
  select <- sprintf(
    "<select id=\"%s\", name=\"%s\">%s</select>", 
    id, 
    id, 
    paste0("\n", c2z:::ToString(options, "\n"), "\n")
  )
  
  return (select)
}


#' @title NestedList
#' @keywords internal
#' @noRd
NestedList <- \(data, 
                parent = "FALSE", 
                folder = "stats", 
                subfolder = "{{< params subfolder >}}",
                lang = "nn") {
  
  
  CreateLi <- \(data, parent, folder, subfolder, lang) {
    
    this.data <- data |>
      dplyr::filter(parentCollection == parent)
    
    sublist <- lapply(seq_len(nrow(this.data)), \(i) {
      x <- this.data[i, ]
      
      if (!is.null(folder)) {
        path <- data |>
          dplyr::filter(key %in% x$paths[[1]]) |>
          dplyr::pull(acronym) |>
          (\(x) do.call(
            file.path, 
            as.list(c(paste0(subfolder, lang), folder, x)))
          )()
        name <- htmltools::HTML(
          sprintf("<a href=\"%s\">%s</a>",  path, x$name)
        )
      } else {
        name <- htmltools::tags$span(x$name, lang = lang) 
      }
      
      name <- htmltools::tags$li(
        name, 
        class = paste0("level", x$level), 
        id = paste0("key-", x$key)
      )
      child.data <- CreateLi(data, x$key, folder, subfolder, lang)
      if (any(length(child.data))) {
        return(htmltools::tagAppendChild(name, htmltools::tags$ul(child.data)))
      } else {
        return(name)
      }
    })
    
    return(sublist)
    
  }
  
  final.list <- htmltools::tags$ul(class = "tree vertical-tree") |>
    htmltools::tagAppendChild(CreateLi(data, parent, folder, subfolder, lang))
  
  return (final.list)
  
}

#' @title RemoveBlank
#' @keywords internal
#' @noRd
RemoveBlank <- \(input.file, output.file = NULL) {
  
  if (is.null(output.file)) output.file <- input.file
  
  # Read the content of the input file
  lines <- readLines(input.file, warn = FALSE, encoding = "UTF-8")
  
  # Remove blank lines
  non.blank.lines <- lines[lines != ""]
  
  # Open the output file for writing (UTF-8 encoding)
  file.conn <- file(output.file, open = "w", encoding = "UTF-8")
  
  # Write the non-blank lines to the output file
  cat(non.blank.lines, file = file.conn, sep = "\n")
  
  # Close the output file
  close(file.conn)
  
}

#' @title Colors
#' @keywords internal
#' @noRd
Colors <- \(palette, n, rgb = FALSE, alpha = NULL, wesanderson = FALSE) {
  
  if (wesanderson) {
    
    colors <- wesanderson::wes_palettes[[palette]][seq_len(n)]
    
  } else {
    
    colors <- RColorBrewer::brewer.pal(n, palette)
    
  }
  
  if (rgb) {
    
    rgb.colors <- grDevices::col2rgb(colors)
    colors <- unlist(lapply(seq_len(ncol(rgb.colors)), \(i) {
      c2z:::ToString(c(rgb.colors[, i], alpha))
    }))
    
  }
  
  return (colors)
  
}

#' @title RemoveEmpty
#' @keywords internal
#' @noRd
RemoveEmpty <- function(x) {
  if (is.list(x)) {
    x <- purrr::discard(x, ~ identical(.x, NULL)) |>
      purrr::map(RemoveEmpty)
  }
  return (Filter(\(x) any(length(x)), x))
}

#' @title RenderSave
#' @keywords internal
#' @noRd
RenderSave <- function(Rmd.path,
                       params,
                       md.dir = NULL,
                       md.name = NULL,
                       output.format = "html_document",
                       keep.yaml = TRUE,
                       silent = TRUE,
                       remove.blank = TRUE) {
  
  # Visible bindings
  output.options <- NULL
  
  # Find Rmd name
  Rmd.name <- basename(Rmd.path)
  # Define md.dir if not defined
  if (is.null(md.dir)) {
    md.dir <- dirname(Rmd.path)
  }
  
  # Create a unique md name if not provided
  if (is.null(md.name)) {
    md.name <- basename(tempfile(tmpdir = md.dir, fileext = ".md"))
  } else {
    md.name <- paste0(md.name, ".md")
  }
  
  # Define output.options
  if (keep.yaml) {
    output.options <- list(
      preserve_yaml = TRUE,
      keep_md = TRUE,
      pandoc_args = "--quiet"
    )
  }
  
  # Render the document
  output_file <- rmarkdown::render(
    input          = Rmd.path,
    params         = params,
    output_file    = md.name,
    output_dir     = md.dir,
    output_format  = output.format,
    output_options = output.options,
    quiet          = silent
  )
  
  # Determine the correct markdown file path.
  # With keep_md = TRUE, rmarkdown typically creates a file with a ".knit.md" suffix.
  md_path_expected <- file.path(md.dir, md.name)
  knit_md_path <- sub("\\.md$", ".knit.md", md_path_expected)
  
  # Use the knit_md_path if it exists; otherwise fallback to md_path_expected.
  target_file <- if (file.exists(knit_md_path)) knit_md_path else md_path_expected
  
  # Remove blank lines from the markdown file if needed.
  if (remove.blank) {
    RemoveBlank(target_file)
  }
  
  return(output_file)
}



#' @title CreateChart
#' @keywords internal
#' @noRd
CreateChart <- function(
    type,
    labels,
    dataset.labels = NULL,
    datasets,
    background.color = NULL,
    fill.background = TRUE,
    legend = TRUE,
    legend.position = "bottom",
    font.color = NULL,
    stack.x = FALSE,
    stack.y = FALSE,
    border.color = NULL,
    border.width = NULL,
    border.radius = 0,
    bar.width = NULL,
    x.axis = TRUE,
    x.text = NULL,
    x.text.color = NULL,
    x.grid = FALSE,
    x.grid.color = NULL,
    y.axis = TRUE,
    y.text = NULL,
    y.text.color = NULL,
    y.grid = FALSE,
    y.grid.color = NULL,
    y.zero = TRUE,
    r.axis = FALSE,
    r.grid.color = NULL,
    r.background = NULL,
    responsive = TRUE,
    aspect.ratio = FALSE,
    line.width = NULL,
    point.background = NULL,
    point.border = NULL,
    point.background.hover = NULL,
    point.border.hover = NULL,
    shortcode = TRUE,
    div.width = NULL,
    div.height = NULL
) {
  
  # Function to set lenght of variables
  LengthElement <- function(element, dataset) {
    if (!any(length(element))) {
      return (NULL) 
    } else if (length(element) != length(dataset)) {
      return(rep(element[[1]], length(dataset)))
    } else if (length(element) == length(dataset)) {
      return(element)
    }
  }
  
  # Checkup
  dataset.labels <- LengthElement(dataset.labels, datasets)
  background.color <- LengthElement(background.color, datasets)
  border.color <- LengthElement(border.color, datasets)
  border.width <- LengthElement(border.width, datasets)
  border.radius <- LengthElement(border.radius, datasets)
  bar.width <- LengthElement(bar.width, datasets)
  
  # Create a list of dataset configurations
  dataset.configs <- lapply(seq_along(datasets), function(i) {
    list(
      label = dataset.labels[[i]],
      data = datasets[[i]],
      backgroundColor = background.color[[i]],
      borderColor = border.color[[i]],
      borderWidth = border.width[[i]],
      borderRadius = border.radius[[i]],
      barThickness = bar.width[[i]]
    )
  })
  
  # Create the scales configuration
  scales.config <- list(
    x = list(
      display = x.axis,
      title = list(
        display = TRUE,
        text = x.text,
        color = x.text.color
      ),
      stacked = stack.x,
      grid = list(
        display = x.grid,
        color = x.grid.color
      ),
      ticks = list(
        color = font.color
      )
    ),
    y = list(
      display = y.axis,
      title = list(
        display = TRUE,
        text = y.text,
        color = y.text.color
      ),
      stacked = stack.y,
      grid = list(
        display = y.grid,
        color = y.grid.color
      ),
      beginAtZero = y.zero,
      ticks = list(
        color = font.color
      )
    )
  )
  
  if (r.axis) {
    r.axis = list(
      angleLines = list(
        color = r.grid.color
      ),
      grid = list(
        color = r.grid.color
      ),
      ticks = list(
        color = font.color,
        backdropColor = r.background
      ),
      pointLabels = list(
        color = font.color
      )
    )
    scales.config <- c(scales.config, r = r.axis)
  }
  
  data <- list(
    type = type,
    data = list(
      labels = labels,
      datasets = dataset.configs
    ),
    options = list(
      elements = list(
        line = list(
          borderWidth = line.width
        )
      ),
      animation = list(
        duration = 500,
        easing = "linear"
      ),
      maintainAspectRatio = aspect.ratio,
      responsive = responsive,
      scales = scales.config, # Add scales configuration
      plugins = list(
        datalabels = list(
          color = font.color
        ),
        legend = list(
          display = legend,
          position = legend.position,
          labels = list(
            color = font.color
          )
        )
      )
    )
  )
  
  # Serialize the JSON structure and remove empty objects
  json <- RemoveEmpty(data) |>
    jsonlite::toJSON(auto_unbox = TRUE) |>
    jsonlite::prettify() |>
    # String to function
    (function(x) gsub("\"\\*code\\*|\\*code\\*\"", "", x))()
  
  if (shortcode) {
    # Complete shortcode
    json <- paste0(
      c2z:::Trim(paste("{{< chart", div.width, div.height, ">}}\n")),
      json, 
      '\n{{< /chart >}}'
    )
  }
  
  return(json)
  
}

#' @title SdgColors
#' @keywords internal
#' @noRd
SdgColors <- \(alpha = 1) {
  c(
    sprintf("rgba(229, 36, 59, %s)", alpha),
    sprintf("rgba(221, 166, 58, %s)", alpha),
    sprintf("rgba(76, 159, 56, %s)", alpha),
    sprintf("rgba(197, 25, 45, %s)", alpha),
    sprintf("rgba(255, 58, 33, %s)", alpha),
    sprintf("rgba(38, 189, 226, %s)", alpha),
    sprintf("rgba(252, 195, 11, %s)", alpha),
    sprintf("rgba(162, 25, 66, %s)", alpha),
    sprintf("rgba(253, 105, 37, %s)", alpha),
    sprintf("rgba(221, 19, 103, %s)", alpha),
    sprintf("rgba(253, 157, 36, %s)", alpha),
    sprintf("rgba(191, 139, 46, %s)", alpha),
    sprintf("rgba(63, 126, 68, %s)", alpha),
    sprintf("rgba(10, 151, 217, %s)", alpha),
    sprintf("rgba(86, 192, 43, %s)", alpha),
    sprintf("rgba(0, 104, 157, %s)", alpha),
    sprintf("rgba(25, 72, 106, %s)", alpha)
  )
}

#' @title SdgLabels
#' @keywords internal
#' @noRd
SdgLabels <- \(lang = "nn") {
  
  if (lang == "nn") {
    
    # Example usage with an unknown number of groups
    labels <- c(
      "Mål 1: Utrydde fattigdom",
      "Mål 2: Utrydde svolt",
      "Mål 3: Gode helse og livskvalitet",
      "Mål 4: God utdanning",
      "Mål 5: Likestilling mellom kjønna",
      "Mål 6: Reint vatn og gode sanitær forhold",
      "Mål 7: Rein energi til alle",
      "Mål 8: Anstendig arbeid og økonomisk vekst",
      "Mål 9: Industri, innovasjon og infrastruktur",
      "Mål 10: Mindre ulikskap",
      "Mål 11: Berekraftig byar og lokalsamfunn",
      "Mål 12: Ansvarleg forbruk og produksjon",
      "Mål 13: Stoppe klimaendringane",
      "Mål 14: Livet i havet",
      "Mål 15: Livet på land",
      "Mål 16: Fred, rettferd og velfungerande institusjonar",
      "Mål 17: Samarbeid for å nå måla"
    )
    
  } else {
    
    labels <- c(
      "Goal 1: No poverty",
      "Goal 2: Zero hunger",
      "Goal 3: Good health and well-being",
      "Goal 4: Quality Education",
      "Goal 5: Gender equality",
      "Goal 6: Clean water and sanitation",
      "Goal 7: Affordable and clean energy",
      "Goal 8: Decent work and economic growth",
      "Goal 9: Industry, innovation and infrastructure",
      "Goal 10: Reduced inequalities",
      "Goal 11: Sustainable cities and communities",
      "Goal 12: Responsible consumption and production",
      "Goal 13: Climate action",
      "Goal 14: Life below water",
      "Goal 15: Life in Land",
      "Goal 16: Peace, Justice and strong institutions",
      "Goal 17: Partnerships for the goals"
    )
    
  }
}

#' @title SdgDoughnut
#' @keywords internal
#' @noRd
SdgDoughnut <- \(lang, 
                 sdg.data = NULL,
                 render = TRUE, 
                 header = TRUE,
                 shortcode = TRUE,
                 div.width = NULL,
                 div.height = NULL,
                 silent = TRUE) {
  
  # Mount Data
  MountData(lang, sdg.data, silent)
  
  # Create numeric sdg data
  data <- as.numeric(sdg.data$sum)
  
  # Define SDG dataset
  datasets <- list(data[data > 0])
  
  # Define SDG Labels
  labels <- SdgLabels(lang)[data > 0]
  
  # Define SDG colors
  background.color <- list(SdgColors()[data > 0])
  
  # Set type as doughnut
  type <- "doughnut"
  
  # Label at bottom
  position <- "bottom"
  
  # Create chart
  chart <- CreateChart(
    type = type,
    labels = labels, 
    dataset.labels = Dict("publication", lang, 2),
    datasets = datasets, 
    background.color = background.color,
    font.color = "black",
    x.axis = FALSE,
    y.axis = FALSE,
    shortcode = shortcode,
    div.width = div.width,
    div.height = div.height
  )
  
  # Create HTML 
  html <- tagList(
    if (header) h1(Dict("sdg.publications", lang, 1)),
    HTML(chart)
  )  |>
    as.character() |>
    c2z4uni:::GoFish(type = NULL)
  
  # Add to MD file
  if (!render) {
    return (html)
  }
  
  RenderSave(
    headless,
    params = list(html = html),
    md.dir = file.path(content, lang, "headless"),
    md.name = "sdg_doughnut"
  )
  
  
}

#' @title SdgOverview
#' @keywords internal
#' @noRd
SdgOverview <- \(lang, 
                 sdg.data = NULL,
                 render = TRUE, 
                 archive.append = NULL,
                 sort = FALSE,
                 delete = FALSE,
                 header = TRUE,
                 silent = TRUE) {
  
  # Mount Data
  MountData(lang, sdg.data, silent)
  
  # Fetch data
  sdg <- c2z4uni:::SdgInfo(
    sdg.sum = sdg.data$sum,
    lang = lang,
    sdg.path = "{{< params subfolder >}}images/sdg",
    archive.url = paste0("{{< params subfolder >}}", lang, "/archive/"),
    archive.append = archive.append,
    sort = sort,
    delete = delete
  ) |>
    paste(collapse = "")
  
  # Create HTML
  html <- tagList(
    if (header) h1(Dict("sdg", lang)),
    div(class = "sdg-container") |>
      tagAppendChild(HTML(sdg))
  ) |>
    as.character() |>
    c2z4uni:::GoFish(type = NULL)
  
  if (!render) {
    return(html)
  }
  
  # Add to MD
  RenderSave(
    headless,
    params = list(html = html),
    md.dir = file.path(content, lang, "headless"),
    md.name = "sdg"
  )
}

#' @title PublicationTren 
#' @keywords internal
#' @noRd
PublicationTrend <- \(data, lang) {
  
  dataset.labels <- c(Dict("publication", lang, 2), Dict("sdg", lang, 2))
  labels <- data$names
  datasets <- list(data$n.publications, data$sdg.sum)
  # Chart configuration
  chart <- CreateChart(
    type = "line",
    labels = labels,
    datasets = datasets,
    dataset.labels = dataset.labels,
    legend.position = "bottom",
    x.text = Dict("year", lang),
    y.text = Dict("n.publications", lang),
    line.width = 2
  )
  
  # Create HTML 
  html <- HTML(chart)
  
  
}

#' @title SdgTrend
#' @keywords internal
#' @noRd
SdgTrend <- \(lang, sdg.data = NULL, header = TRUE, silent = TRUE) {
  
  # Mount Data
  MountData(lang, sdg.data, silent)
  
  # Main publishing faculties
  ids <- c("209.0.0.0", "209.2.0.0", "209.4.0.0", "209.5.0.0", "209.6.0.0")
  # Find units
  
  units <- dplyr::filter(unit.paths, id %in% ids) |>
    dplyr::mutate(
      sdg = purrr::map(key, ~ SdgSum(
        .x, monthlies, sdg.data, "year.month", TRUE, TRUE)
      )
    )
  
  dataset.labels <- toupper(units$acronym)
  labels <- names(table(monthlies$year))
  datasets <- lapply(units$sdg, \(x) x$sdg.sum)
  
  # Chart configuration
  chart <- CreateChart(
    type = "line",
    labels = labels,
    datasets = datasets,
    dataset.labels = dataset.labels,
    legend.position = "bottom",
    x.text = Dict("year", lang),
    y.text = Dict("n.publications", lang),
    line.width = 2
  )
  # Create HTML 
  html <- tagList(
    if (header) h1(Dict("sdg.publications", lang, 1)),
    HTML(chart) 
  )  |>
    as.character() |>
    c2z4uni:::GoFish(type = NULL)
  
  RenderSave(
    headless,
    params = list(html = html),
    md.dir = file.path(content, lang, "headless"),
    md.name = "sdg_trend"
  )
  
}

#' @title SdgUnits
#' @keywords internal
#' @noRd
SdgUnits <- \(lang, sdg.data = NULL, header = TRUE, silent = TRUE) {
  
  # Mount Data
  MountData(lang, sdg.data, silent)
  
  # Main publishing faculties
  ids <- c("209.2.0.0", "209.4.0.0", "209.5.0.0", "209.6.0.0")

  # Find units
  units <- dplyr::filter(unit.paths, id %in% ids) |>
    dplyr::mutate(
      sdg = purrr::map(key, ~ SdgSum(.x, monthlies, sdg.data))
    )
  
  labels <- toupper(units$acronym)
  dataset.labels <- as.list(SdgLabels())
  datasets <-   as.list(
    do.call(dplyr::bind_rows,lapply(units$sdg, \(x) x$sdg.sum))
  )
  background.color <- as.list(SdgColors(1))
  # Create a stacked bar chart shortcode
  chart <- CreateChart(
    type = "bar",
    labels = labels,
    dataset.labels = dataset.labels,
    datasets = datasets,
    background.color = background.color,
    font.color = "black",
    stack.x = TRUE,
    stack.y = TRUE
  )
  
  # Create HTML 
  html <- tagList(
    if (header) h1(Dict("sdg.publications", lang, 1)),
    HTML(chart)
  ) |>
    as.character() |>
    c2z4uni:::GoFish(type = NULL)
  
  RenderSave(
    headless,
    params = list(html = html),
    md.dir = file.path(content, lang, "headless"),
    md.name = "sdg_units"
  )
  
}

#' @title About
#' @keywords internal
#' @noRd
About <- \(lang) {
  RenderSave(
    eval(parse(text = paste0("about.", lang))),
    params = list(html = html),
    md.dir = file.path(content, lang, "headless"),
    md.name = "about",
    remove.blank = FALSE
  )
}

#' @title SendEmail
#' @keywords internal
#' @noRd
SendEmail <- \(subscribers, email.data, silent = FALSE) {
  
  email <- emayili::envelope(
    reply = "oystein.skaar@inn.no",
    to = "CRIStin Bot <c2z.tool@gmail.com>",
    from = "CRIStin Bot <c2z.tool@gmail.com>",
    bcc = subscribers,
    subject = email.data$subject,
    html = email.data$body
  )
  
  smtp <- emayili::server(
    host = "smtp.gmail.com",
    port = 465,
    username = "c2z.tool@gmail.com",
    password = Sys.getenv("GMAIL_API")
  )
  
  send <- c2z:::Online(smtp(email), message = "Newsletter", silent = silent)
  
}

MdFiles <- \(path) {
  # List all .md files in the directory
  all.md.files <- list.files(path, pattern = "\\.md$")
  # Use grep to filter out _index
  md.files <- all.md.files[!grepl("_index\\.md$", basename(all.md.files))]
  
  return (md.files)
}

#' @title GetLibrary
#' @keywords internal
#' @noRd
LibraryPost <- \(lang = "en", 
                 post.lang = "en",
                 locale = "en_US", 
                 unit.id = "209.0.0.0",
                 email.unit = NULL,
                 user.cards = TRUE,
                 start.date = NULL, 
                 end.date = NULL, 
                 post = FALSE,
                 post.only = FALSE,
                 update = FALSE,
                 full.update = FALSE,
                 get.unpaywall = TRUE,
                 get.ezproxy = TRUE,
                 use.identifiers = TRUE,
                 use.citeproc = TRUE,
                 use.multisession = TRUE,
                 n.workers = NULL,
                 handler = "cli",
                 restore.defaults = FALSE,
                 silent = FALSE,
                 sdg.host = "http://localhost:6963/process",
                 log = list()) {
  
  
  # Fetch updated data if update is TRUE
  if (update) {
    
    # Set star date as 1 month ago from floored sys.date
    ## Eg. "2023-10-10" -> "2023-10-01" -> "2023-09-01"
    if (is.null(start.date)) {
      start.date <- c2z:::ChangeDate(c2z:::FloorDate(Sys.Date()), -1)
    }
    
    # Fetch library
    cristin.monthly <- CristinMonthly(
      zotero,
      unit.id = unit.id,
      start.date = start.date,
      end.date = end.date,
      local.storage = local.storage,
      sdg.host = sdg.host,
      locale = locale,
      post = post,
      post.only = post.only,
      full.update = full.update,
      get.unpaywall = get.unpaywall,
      get.ezproxy = get.ezproxy,
      use.identifiers = use.identifiers,
      use.citeproc = use.citeproc,
      use.multisession = use.multisession,
      n.workers = n.workers,
      handler = handler,
      restore.defaults = restore.defaults,
      lang = lang,
      post.lang = post.lang
    )
    
  }
  
  if (post) return (cristin.monthly)
  
  # Mount Data
  MountData(lang)
  
  # Log
  log <-  c2z:::LogCat(
    "Creating email",
    silent = silent,
    log = log
  )
  
  if (is.null(email.unit)) email.unit <- unit.id
  
  # Create email
  email <- CristinMail(
    unit.id = email.unit, 
    monthlies,
    unit.paths,
    "https://oeysan.github.io/c2z4inn",
    lang = lang
  )
  
  # Log
  log <-  c2z:::LogCat(
    "Creating JSON data",
    silent = silent,
    log = log
  )
  
  # Create JSON data
  
  ## File path
  json.path <- file.path(
    getwd(), "static", "data", paste0("data_", lang, ".json.gz")
  )
  
  ## Create JSON data
  json <- CristinJson(
    dplyr::arrange(monthlies, desc(year.month)),
    unit.paths,
    sdg.data = sdg.data,
    user.cards = user.cards,
    local.storage = local.storage, 
    use.multisession = use.multisession,
    lang = lang
  )
  
  # Specify the compressed file path
  compressed.file <- gzfile(json.path, "wb")
  # Write the compressed JSON data to the file
  writeLines(json, con = compressed.file)
  # Close the compressed file
  close(compressed.file)
  
  # Creating publication folder if it does not exist
  pub <- if (lang == "nn") pub.nn else pub.en
  dir.create(
    pub,
    showWarnings = FALSE,
    recursive = TRUE
  )
  
  # MD files in publications without extension that are not updated
  md.files <- gsub("\\.md", "", MdFiles(pub)) |>
    stringr::str_replace("\\.md", "")
  
  # Deleted keys
  deleted.md  <- setdiff(md.files, monthlies$key)
  
  # Remove deleted files
  if (any(length(deleted.md))) {
    
    # Log
    log <-  c2z:::LogCat(
      "Deleting removed MD files",
      silent = silent,
      log = log
    )
    
    file.remove(file.path(pub, paste0(deleted.md, ".md")))
  }
  
  missing.md  <- setdiff(monthlies$key, md.files)
  updated.keys <- unique(missing.md, updated.keys)
  
  # Find new or updated keys
  new.pages <- monthlies |>
    dplyr::filter(key %in% updated.keys)
  
  # Log
  log <-  c2z:::LogCat(
    "Creating MD files",
    silent = silent,
    log = log
  )

  if (!any(nrow(new.pages))) {
    return (NULL)
  }

  # Create web pages
  web <- CristinWeb(
    new.pages,
    sdg.data,
    "{{< params subfolder >}}images/sdg",
    archive.url = paste0("{{< params subfolder >}}", lang, "/archive/"),
    md.path = pub,
    md.save = TRUE,
    user.cards = user.cards,
    local.storage = local.storage,
    lang = lang,
    use.multisession = 50,
    n.workers = n.workers,
    handler = handler,
    restore.defaults = restore.defaults,
  )
  log <- web$log
  web <- web$results
  
  updated_keys <- c2z4uni:::LocalStorage(
    "updated_keys", 
    local.storage,
    NULL,
    message = "Resetting updated keys",
    lang = lang,
    silent = silent
  )
  
  return("Completed")
  
}


LibraryUpdate <- \(unit.id = "209.0.0.0", lang = "nn", pages = TRUE) {
  
  if (lang == "nn") { 
    locale <- "nn-NO"
  } else {
    locale <- "en-US"
  }
  
  if (pages) {
    # Fetch English library
    lib <- LibraryPost(
      unit.id = unit.id, 
      lang = lang, 
      locale = locale,
      update = TRUE,
      post = FALSE
    )
  }
  
  # Mount data
  MountData(lang, silent = FALSE)
  
  print("Updating SDG Overview")
  
  # Create SDG overview
  SdgOverview(lang)
  
  print("Updating Doughnuts")
  
  # Create doughtnuts
  SdgDoughnut(lang)
  
  print("Updating SDG by Units")
  
  # Create SDG by units
  SdgUnits(lang)
  
  print("Updating Publication Trends")
  
  # Create SDG trend
  SdgTrend(lang)
  
  print("Updating Descriptive Statistics")
  
  # Create stats
  CreateStats(lang)
  
  print("Updating About Pages")
  
  # Create about
  About(lang)
  
  return ("Completed")
  
}
