
library(plotly)
library(htmlwidgets)

# Read the saved data from Module 6.
d <- read.csv("../data/emissions_1850_2024.csv")
countries <- c("Brazil", "China", "India", "World")
d <- subset(d, Entity %in% countries & Year >= 1850 & Year <= 2024)
d <- d[order(d$Entity, d$Year), ]
stopifnot(nrow(d) == 700, !anyNA(d),
          !anyDuplicated(d[c("Entity", "Year")]))

colours <- c("#693B90", "#146196", "#985410", "#34383D")
patterns <- c("solid", "dash", "dot", "dashdot")

# Hover labels and clickable legend entries are built into Plotly.
p <- plot_ly(height = 720)
for (i in seq_along(countries)) {
  country_data <- subset(d, Entity == countries[i])
  p <- add_trace(
    p, data = country_data,
    x = ~Year, y = ~ghg_tonnes_per_person,
    type = "scatter", mode = "lines", name = countries[i],
    line = list(color = colours[i], dash = patterns[i], width = 2.5),
    hovertemplate = paste0(
      countries[i], "<br>Year: %{x:.0f}",
      "<br>Emissions: %{y:.1f} tonnes CO₂e per person<extra></extra>"
    )
  )
}

p <- layout(
  p,
  title = list(
    text = paste0("Greenhouse gas emissions per person",
                  "<br><sup>Brazil, China, India and the world, 1850–2024 · Includes land use</sup>"),
    x = 0.02, xanchor = "left", font = list(size = 21)
  ),
  font = list(family = "Arial", size = 14, color = "#222222"),
  margin = list(l = 90, r = 25, t = 145, b = 65),
  legend = list(orientation = "h", x = 0, y = 1.02, yanchor = "bottom",
                itemclick = "toggle", itemdoubleclick = FALSE),
  xaxis = list(
    title = "Year", range = c(1850, 2024), dtick = 25,
    rangeslider = list(visible = TRUE, thickness = 0.16)
  ),
  yaxis = list(
    title = "Tonnes of CO₂ equivalents per person",
    range = c(0, 25), dtick = 5, fixedrange = TRUE,
    gridcolor = "#DDDDDD", zerolinecolor = "#AAAAAA"
  ),
  hovermode = "x unified", dragmode = FALSE,
  paper_bgcolor = "white", plot_bgcolor = "white"
)


p <- config(p, displayModeBar = FALSE, scrollZoom = FALSE, responsive = TRUE)


dir.create("../figures", showWarnings = FALSE)
saveWidget(p, "../figures/module9_interactive.html", selfcontained = TRUE,
           title = "Module 9 interactive emissions chart")
p


