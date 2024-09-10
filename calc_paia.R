calc_paia = function(points_scale,
                     points_positional,
                     points_tuberosity){

  d = rbind.data.frame(
    points_scale, points_positional, points_tuberosity
  )
  
  left_bottom_index = which.min(points_positional$x * points_positional$y) + dim(points_scale)[1]
  right_up_index = which.max(points_positional$x * points_positional$y) + dim(points_scale)[1]
  
  insertion_peak_index = dim(d)[1]
  scale_index_range = c(1,dim(points_scale)[1], 1)
  marker_index_range = c(dim(points_scale)[1]+1, dim(points_scale)[1] + dim(points_positional)[1])
  insertion_index_range = c(dim(points_scale)[1]+dim(points_positional)[1]+1,dim(d)[1])
  
  scale_index_start = scale_index_range[1]
  scale_index_end = scale_index_range[2]
  marker_index_start = marker_index_range[1]
  marker_index_end = marker_index_range[2]
  insertion_index_start = insertion_index_range[1]
  insertion_index_end = insertion_index_range[2]
  
  names(d) = c("x", "y")
  
  scale_factor_x = ((d$x[right_up_index] - d$x[left_bottom_index])^2 +
                      (d$y[right_up_index] - d$y[left_bottom_index])^2)^0.5
  scale_factor_y = ((d$x[right_up_index] - d$x[left_bottom_index])^2 +
                      (d$y[right_up_index] - d$y[left_bottom_index])^2)^0.5
  
  d$index = 1:dim(d)[1]
  d$anno = NA
  d$anno[scale_index_start:scale_index_end] = "scale"
  d$anno[marker_index_start:marker_index_end] = "marker"
  d$anno[insertion_index_start:insertion_index_end] = "insertion"
  
  wb_x = d$x[length(d$x)]    # Find weightbearing X coord
  wb_y = d$y[length(d$y)]    # Find weightbearing Y coord
  d$x = d$x - wb_x           # Zero at weightbearing point
  d$y = d$y - wb_y           # Zero at weightbearing point
  d$x = d$x/scale_factor_x   # Standardize X scale
  d$y = d$y/scale_factor_y   # Standardize Y scale
  
  # Define insertion pizza center
  insertion_peak_x = d$x[d$index==insertion_peak_index] # Pizza center point
  insertion_peak_y = d$y[d$index==insertion_peak_index] # Pizza center point
  
  d$x = d$x - insertion_peak_x # Zero at pizza center point
  d$y = d$y - insertion_peak_y # Zero at pizza center point
  
  # Define box
  left_bottom_x = d$x[d$index==left_bottom_index]
  left_bottom_y = d$y[d$index==left_bottom_index]
  right_up_x = d$x[d$index==right_up_index]
  right_up_y = d$y[d$index==right_up_index]
  
  # Use pre-fit scaling variables
  x_o_scale = 0.412
  y_o_scale = 0.454
  rd_scale = 0.417
  
  # Define the standard circle
  x_length = right_up_x - left_bottom_x
  y_length = right_up_y - left_bottom_y
  
  o_x = x_length*x_o_scale + left_bottom_x
  o_y = y_length*y_o_scale + left_bottom_y
  r = (x_length^2 + y_length^2)^0.5*rd_scale
  
  # Plot specific circle
  gg_circle = function(r, xc, yc, color="black", fill=NA, ...) {
    x = xc + r*cos(seq(0, pi, length.out=100))
    ymax = yc + r*sin(seq(0, pi, length.out=100))
    ymin = yc + r*sin(seq(0, -pi, length.out=100))
    annotate("ribbon", x=x, ymin=ymin, ymax=ymax, color=color, fill=fill, ...)
  }
  
  # Get standard circle based on y
  get_standard_circle_x = function(y, o_x, o_y, r){
    return((r^2-(y-o_y)^2)^0.5 + o_x)
  }
  
  # Define standard circle curve
  standard_circle_x = sapply(d$y[d$anno=="insertion"],
                             get_standard_circle_x, o_x, o_y, r)
  original_curve_x = d$x[d$anno=="insertion"]
  original_curve_y = d$y[d$anno=="insertion"]
  
  # Transform curves to the original axis
  standard_circle_x_transformed = standard_circle_x * scale_factor_x
  original_curve_x_transformed = original_curve_x * scale_factor_x
  original_curve_y_transformed = original_curve_y * scale_factor_y
  
  # Construct transformation data frame
  original_curve_transformed = data.frame(x = original_curve_x_transformed,
                                          y = original_curve_y_transformed)
  standard_circle_transformed = data.frame(x = standard_circle_x_transformed,
                                           y = original_curve_y_transformed)
  
  # Calculate original loss
  original_loss = mean(abs(standard_circle_transformed$x - original_curve_transformed$x))
  
  # Determining the best rotational angle
  rotational_loss_vector = vector()
  rotation_angles = seq(0, pi/6, 0.001)
  for(rotation_angle in rotation_angles){
    post_rotation_xy = Rotation(original_curve_transformed, 
                                rotation_angle)
    post_rotation_xy = as.data.frame(post_rotation_xy)
    names(post_rotation_xy) = c("x","y")
    
    # Calculate rotational loss
    rotational_loss = abs(post_rotation_xy$x - standard_circle_transformed$x)
    rotational_loss = mean(rotational_loss)
    rotational_loss_vector = c(rotational_loss_vector, rotational_loss)
  }
  
  # Compiling loss and obtain optimum angle
  loss_df = data.frame(angle = rotation_angles, 
                       loss = rotational_loss_vector)
  loss_df$angle = loss_df$angle * 180 / pi
  optimum_insertion_angle = loss_df$angle[which.min(loss_df$loss)[1]]
  
  # Plot loss
  plt_loss = ggplot(data = loss_df, aes(x = angle, y = loss)) + 
    geom_line() + 
    xlab("Insertion Angle (Degree)") + 
    ylab("Rotational Loss") +
    ggtitle(label = paste0("Optimal Insertion Angle: ", 
                           round(optimum_insertion_angle,1),
                           " Degrees")) + 
    theme_pubr() +
    theme(text = element_text(size = 15), 
          plot.title = element_text(size = 15))
  plt_loss = ggplotly(plt_loss)

  # Plot simulated rotation
  optimum_insertion_radian = optimum_insertion_angle*pi/180
  post_rotation_xy = Rotation(original_curve_transformed, 
                              optimum_insertion_radian)
  post_rotation_xy = as.data.frame(post_rotation_xy)
  names(post_rotation_xy) = c("x","y")
  
  post_rotation_xy$index = -1
  post_rotation_xy$anno = "Post-IAT"
  post_rotation_xy$x = post_rotation_xy$x / scale_factor_x
  post_rotation_xy$y = post_rotation_xy$y / scale_factor_y
  post_rotation_xy = rbind.data.frame(d, post_rotation_xy)
  
  post_rotation_xy$anno[post_rotation_xy$anno=="marker"] = "Positional Marker"
  post_rotation_xy$anno[post_rotation_xy$anno=="insertion"] = "Pre-IAT"
  post_rotation_xy = filter(post_rotation_xy, anno != "scale")
  post_rotation_xy = post_rotation_xy[,-3]
  
  plt_rotated = ggplot(data = post_rotation_xy,
                       aes(x = x, y = y, anno = anno)) +
    geom_point(aes(fill = anno), shape = 21, color = "black") +
    gg_circle(r=r, xc=o_x, yc=o_y) + 
    labs(fill = "") +
    xlab("Standardized X") +
    ylab("Standardized Y") +
    theme_pubr() +
    theme(text = element_text(size = 15))
  plt_rotated = ggplotly(plt_rotated)
  
  results = list(
    loss_df = loss_df,
    post_rotation_xy = post_rotation_xy,
    optimum_insertion_angle = optimum_insertion_angle,
    plt_loss = plt_loss,
    plt_rotated = plt_rotated
  )
  
  return(results)
  
}

