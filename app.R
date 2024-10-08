source("setup.R")
source("calc_paia.R")

ui = fluidPage(
  theme = shinytheme("readable"),
  tags$style(HTML("
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; /* Default Shiny font stack */
    }
  ")),
  titlePanel("PAIA"),
  helpText("Calculating Pathologic Achilles Insertion Angles (PAIAs) using X-Ray Scans"),
  
  sidebarLayout(
    sidebarPanel(width = 4,
                 h4("Instructions"),
                 p("Upload an X-ray scan image of the foot in JPEG format,
        annotate the scale, positional and calcaneal tuberosity markers,
        and click run PAIA to calculate the most optimum insertion angle."),
                 p("For more instructions, please refer to the",  a("GitHub repo", href = "https://github.com/Broccolito/paia", 
                                             target = "_blank"), "."),
                 fileInput("file", "Upload an X-ray Scan", accept = c("image/jpeg")),
                 selectInput("color", "Select Annotation Type", 
                             choices = c("Scale" = "#1B9E77", "Positional" = "#7570B3", "Calcaneal Tuberosity" = "#D95F02"), 
                             selected = "Scale"),
                 actionButton("clear", "Clear All Annotations"),
                 br(),br(),
                 verbatimTextOutput("click_info"),
                 actionButton("run", "Calculate PAIA")
    ),
    mainPanel(
      plotOutput("image_plot", click = "plot_click", brush = "plot_brush",
                 width = "100%", height = "500px"),
      uiOutput("paia_result")
    )
  )
)

server = function(input, output, session) {
  
  # Initialize reactive values to store click points for different colors and the image
  rv = reactiveValues(
    click_points_scale = data.frame(x = numeric(), y = numeric()),
    click_points_positional = data.frame(x = numeric(), y = numeric()),
    click_points_tuberosity = data.frame(x = numeric(), y = numeric()),
    img = NULL
  )
  
  # Observe the file input and load the uploaded image
  observeEvent(input$file, {
    req(input$file)
    img_path = input$file$datapath
    rv$img = readJPEG(img_path)  # Read the uploaded JPEG image
  })
  
  # Render the image plot
  output$image_plot = renderPlot({
    req(rv$img)  # Ensure an image is uploaded
    plot(1:2, type = "n", xlim = c(0, 1), ylim = c(0, 1),
         xlab = "", ylab = "", axes = FALSE)
    rasterImage(rv$img, 0, 0, 1, 1)
    
    # Draw points for each color
    if (nrow(rv$click_points_scale) > 0) {
      points(rv$click_points_scale$x, rv$click_points_scale$y, 
             col = "#1B9E77", pch = 19, cex = 1.5)
    }
    if (nrow(rv$click_points_positional) > 0) {
      points(rv$click_points_positional$x, rv$click_points_positional$y, 
             col = "#7570B3", pch = 19, cex = 1.5)
    }
    if (nrow(rv$click_points_tuberosity) > 0) {
      points(rv$click_points_tuberosity$x, rv$click_points_tuberosity$y, 
             col = "#D95F02", pch = 19, cex = 1.5)
    }
  })
  
  # Observe the click input to capture click points based on selected color
  observeEvent(input$plot_click, {
    click = input$plot_click
    
    if (!is.null(click)) {
      new_point = data.frame(x = round(click$x, 3), y = round(click$y, 3))  # Round to 3 digits
      
      # Store the click points in the corresponding data frame based on selected color
      if (input$color == "#1B9E77") {
        rv$click_points_scale = rbind(rv$click_points_scale, new_point)
      } else if (input$color == "#7570B3") {
        rv$click_points_positional = rbind(rv$click_points_positional, new_point)
      } else if (input$color == "#D95F02") {
        rv$click_points_tuberosity = rbind(rv$click_points_tuberosity, new_point)
      }
    }
  })
  
  # Display the click points for all colors
  output$click_info = renderText({
    format_df = function(df, title) {
      if (nrow(df) == 0) {
        return(paste0(title, ": \nNo points selected.\n"))
      } else {
        df_text = paste(apply(df, 1, function(row) paste("(", row[1], ", ", row[2], ")", sep = "")), collapse = "\n")
        return(paste0(title, ":\n", df_text, "\n"))
      }
    }
    
    scale_info = format_df(rv$click_points_scale, "Scale Markers")
    positional_info = format_df(rv$click_points_positional, "Positional Markers")
    tuberosity_info = format_df(rv$click_points_tuberosity, "Calcaneal Tuberosity Markers")
    
    paste(scale_info, positional_info, tuberosity_info, sep = "\n")
  })
  
  # Clear all the click points when the button is clicked
  observeEvent(input$clear, {
    rv$click_points_scale = data.frame(x = numeric(), y = numeric())
    rv$click_points_positional = data.frame(x = numeric(), y = numeric())
    rv$click_points_tuberosity = data.frame(x = numeric(), y = numeric())
  })
  
  observeEvent(input$run, {
    
    results = calc_paia(points_scale = rv$click_points_scale,
                        points_positional = rv$click_points_positional,
                        points_tuberosity = rv$click_points_tuberosity)
    
    results$post_rotation_xy$x = round(results$post_rotation_xy$x, 3)
    results$post_rotation_xy$y = round(results$post_rotation_xy$y, 3)
    
    output$paia_result = renderUI({
      div(
        h2("Results:"),
        hr(),
        h4("Rotational Loss"),
        div(renderPlotly({results$plt_loss})),
        br(),br(),
        h4("Pre-/Post-IAT Rotation"),
        div(renderPlotly({results$plt_rotated})),
        br(),br(),
        h4("Pre-/Post-IAT Rotation Standardized Coordinates"),
        div(renderDT({
          datatable(
            results$post_rotation_xy,
            extensions = 'Buttons',
            options = list(
              dom = 'Bfrtip',
              buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
            )
          )
        }))
      )
    })
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
