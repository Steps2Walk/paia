# PAIA: Pathologic Achilles Insertion Angle

This is a repository of an R Shiny application that can calculate the optimal PAIA for Zadek osteotomy.  **PAIA** (Pathologic Achilles Insertion Angle) is a novel radiographic metric developed to evaluate and treat Insertional Achilles Tendinopathy (IAT) using X-ray scans. This tool provides a quantitative method to measure the enlarged calcaneal tuberosity and guides the individualized design of the Zadek osteotomy, a minimally invasive surgical procedure for IAT.

## Overview

Insertional Achilles tendinopathy (IAT) is a common cause of posterior heel pain characterized by calcification and degenerative changes at the Achilles insertion on the calcaneus. Traditional surgical treatments, including debridement and repair or reconstruction, often involve long recovery periods. The Zadek osteotomy, a dorsal closing wedge osteotomy on the calcaneus, offers a less invasive alternative with reduced postoperative pain, swelling, scarring, and recovery time.

The **PAIA** metric was developed to address the lack of standardized methods to design the size and apex of the Zadek osteotomy based on the severity of calcaneal enlargement in IAT patients. Using lateral weight-bearing X-ray images, PAIA provides a mathematical algorithm to predict the ideal contour of the calcaneal tuberosity and determine the optimal insertion angle for surgical planning.

## Methodology

### Study Design

1. **Selection of Study Samples:**
   - **Control Group:** Lateral weight-bearing X-ray images of 40 feet without IAT or other Achilles insertion deformities were analyzed to study the normal morphology of the calcaneal tuberosity.
   - **Diseased Group:** Lateral weight-bearing X-ray images of 40 feet with IAT were used to study the pathologic morphology.
2. **Development of the Standard Circle:**
   - The 40 control radiographs were analyzed to plot 90 positional markers on each calcaneus to determine the size and contour of the calcaneal tuberosity.
   - An individualized "Standard Circle" was mathematically fitted for each subject using the relative x and y coordinates of the circle's center and radius, scaled according to the dimensions of the calcaneus.
3. **Determination of PAIA:**
   - The enlarged tuberosities in the diseased group were outlined using positional markers and rotated around the weight-bearing point to align with their respective ideal contours predicted by the Standard Circles.
   - The most optimal rotation angle, named the **Pathologic Achilles Insertion Angle (PAIA)**, was calculated to describe the enlargement of the calcaneal tuberosity and guide the Zadek osteotomy.

### Calculation of PAIA

The PAIA is determined using the following steps:

1. **Mapping the Control and Diseased Groups:**
   - All control and IAT images are mapped to their respective Standard Circles, using the center and radius determined from the control feet.
2. **Alignment and Optimization:**
   - The enlarged posterior contour of the calcaneal tuberosity in IAT feet is rotated around the weight-bearing point to best align with the ideal Standard Circle.
   - The optimal rotation angle is calculated by minimizing the rotational loss, which measures differences between the rotated enlarged tuberosities and the Standard Circles.
3. **Mathematical Formulation:**
   - The optimal rotation angle is determined using a sum of squared errors (SSE) optimization technique to find the minimum difference between the rotated enlarged contour and the ideal Standard Circle.

## Try the PAIA Application

You can try the PAIA application using this [link](https://wag001.shinyapps.io/paia/). For faster performance and full functionality, follow the steps below to run the PAIA application locally.

## Installation and Requirements

To use the PAIA tool, you need to have R and Shiny installed. You also need the following packages:

`shiny`, `shinythemes`, `jpeg`, `DT`, `ggplot2`, `ggpubr`, `dplyr`, and `plotly`.

You can install these packages using:

```
install.packages(c("shiny", "shinythemes", "jpeg", "DT", "ggplot2", "dplyr", "plotly"))
```

## Usage

### Running the Application

1. Clone or download the repository:

```
git clone https://github.com/Broccolito/paia.git
cd paia
```

1. Run the Shiny app in R:

```
library(shiny)
runApp("app.R")
```

### User Guide

1. **Upload an X-ray Scan:**
   - Upload a lateral weight-bearing X-ray scan of the foot in JPEG format by clicking the "Upload an X-ray Scan" button.
2. **Annotate the Markers:**
   - Use the dropdown menu to select the type of annotation:
     - **Scale:** Mark the scale for measurement calibration.
     - **Positional:** Mark the positional reference points.
     - **Calcaneal Tuberosity:** Mark the contour of the calcaneal tuberosity.
   - Click on the X-ray image to place the selected markers.
   - An example annotation looks like this: ![img](method/demo.png)
3. **Clear Annotations:**
   - Click the "Clear All Annotations" button to reset the markers if needed.
4. **Calculate PAIA:**
   - Click the "Calculate PAIA" button to run the analysis and calculate the optimal insertion angle.
   - The results, including rotational loss plots, rotation coordinates, and the optimal insertion angle, will be displayed.
5. **Export Results:**
   - You can export the standardized coordinates and other results in various formats (CSV, Excel, PDF) using the download buttons in the results section.

### Additional Resources

For more detailed instructions and explanations, please refer to the [PAIA GitHub Repository](https://github.com/Broccolito/paia).

## Methodological Details

For a comprehensive understanding of the methodology, please refer to the [detailed methods](method/paia_method.pdf) as well as the manuscript: <br>
"Pathologic Achilles Insertion Angle: A Novel Radiographic Metric to help Evaluate and Treat Insertional Achilles Tendinopathy" by Wanjun Gu, Melissa Carpenter, Mingjie Zhu, Ankit Hirpara, Kenneth J. Hunt, Mark S. Myerson, and Shuyuan Li.

## Contributors

- **Wanjun Gu** - University of California, San Francisco
- **Melissa Carpenter**, **Mingjie Zhu**, **Ankit Hirpara**, **Kenneth J. Hunt**, **Mark S. Myerson**, **Shuyuan Li** - University of Colorado School of Medicine

## License

This project is licensed under the MIT License.

## Acknowledgements

We thank all contributors and institutions involved in this study. For more details, please refer to the manuscript and related publications.
