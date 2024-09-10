# PAIA Methodology

## Selection of Study Samples

- **Control Group**: Lateral weight-bearing X-ray images of 40 feet without Insertional Achilles Tendinopathy (IAT), other Achilles insertion deformities, trauma history of the calcaneus, or other deformities were included to study the normal morphology of the calcaneal tuberosity.
- **Diseased Group**: Lateral weight-bearing X-ray images of 40 feet with IAT were analyzed to study the pathologic morphology.

## Delineating the Contour of Control Calcaneal Tuberosities

The 40 control radiographs were imported into ImageJ software. Each calcaneus was circumscribed within a rectangle such that each side of the rectangle corresponded to the anterior, superior, posterior, and inferior borders of the calcaneus. 

- **Positional Markers**: 
  - 90 positional markers were plotted on each calcaneus to determine the size of the calcaneus and the contour of the calcaneal tuberosity.
  - Points 1-3 were set up as calibration markers for measurement purposes.
  - Other points were either standardized anatomical markers or evenly distributed between anatomical markers along the contour of the bone for mapping purposes.

## Determining the Individualized Standard Circle to Predict the Ideal Calcaneal Tuberosity Contour

The 90 positional markers were collectively mapped to construct and statistically fit an individualized **Standard Circle** for each subject.

1. **Fitting the Standard Circle**:
   - The positioning and shape of the standard rectangle were characterized by points 4, 5, 6, and 7, with point 7 denoted as the origin of the x and y coordinates (i.e., \(x, y = 0\) at point 7).
   - The standard rectangle was normalized to a unit square to account for differences in foot sizes between subjects.

2. **Parameters of the Standard Circle**:
   - Two essential parameters used to define the individualized Standard Circle for each calcaneal tuberosity:
     - Relative x and y coordinates of the circle's center, denoted as \(O(x_o, y_o)\).
     - Radius (R) of the Standard Circle, determined by bone markers representing the dimensions of the calcaneus, including height, length, and the Calcaneal Pitch angle.

The goal of the Standard Circle was to delineate the contour that best approximates the posterior outline of an "ideally relatively normal" calcaneal tuberosity using the calcaneus's dimensions.

### Mathematical Definition of the Standard Circle

- The center of the Standard Circle was denoted as \(O(x_o, y_o)\).
- Three corners of the rectangle were:
  - \(A(0,0)\) corresponding to point 7,
  - \(B(x_B, 0)\) corresponding to point 6,
  - \(C(0, y_C)\) corresponding to point 4.

- The width, height, and diagonal length of the rectangle were denoted as \(x_B\), \(y_C\), and \(D\), respectively, where:

\[
D = \sqrt{x_B^2 + y_C^2}
\]

- Each point on the curvature of the control calcaneal tuberosity was standardized along the x and y axes and approximated using the following equation for the Standard Circle:

\[
(x - x_0)^2 + (y - y_0)^2 = R^2
\]

where:

- \(x_0\) and \(y_0\) are the offsets of the circle's center from the x and y axes, respectively.

### Parameterization and Visualization of the Standard Circle

- For all control calcaneal tuberosities, their respective \(x_o\), \(y_o\), and circle radius \(R\) were calculated to construct distributions with averages and standard errors to parameterize the Standard Circle.
- The average x offset, y offset, and radius of the standard circle were calculated for all control feet.
- All plotting points, as well as the average Standard Circle fitted using the 40 control feet, were visualized.

## Developing the Pathologic Achilles Insertion Angle (PAIA)

The calcaneal tuberosities of the 40 feet with IAT were analyzed by circumscribing the same positional bone markers as defined in the control feet, while intentionally excluding the enlargement of the calcaneal tuberosity.

1. **Analyzing Diseased Feet**:
   - For feet with IAT, only the four corners of the rectangle and anatomical markers were plotted to collect dimensional information.
   - Individualized Standard Circles were created for all individuals with IAT.

2. **Outlining Enlarged Posterior Contour**:
   - The enlarged posterior contour of the calcaneal tuberosities with IAT was outlined using positional bone markers 37–90 to collect the x and y coordinate information.
   - These enlarged contours were rotated around the weight-bearing point (point 90) to best align with their respective "ideal" curvatures predicted by the Standard Circles using mathematical optimization.

### Mathematical Optimization for PAIA

The optimization was performed by projecting the y-coordinates of each plotted point on the enlarged posterior tuberosity \(y_i\) onto the Standard Circle of that calcaneus. The Standard Circle (SC), upon projection, can be written as:

\[
\text{SC} = 
\begin{bmatrix}
\text{SC}_x \\
\text{SC}_y
\end{bmatrix}
=
\begin{bmatrix}
\sqrt{R^2 - (y_i - y_o)^2} + x_o \\
y_i
\end{bmatrix}
\]

where \(\text{SC}_x\) and \(\text{SC}_y\) are the x and y coordinates of all points on the Standard Circle. The x-coordinates of the projected Standard Curve can be expressed as a function of the y-coordinates.

### Rotational Loss Calculation

- **Rotational Loss**: Defined as a mean square error measuring differences between the rotated enlarged calcaneal tuberosities and the Standard Circles of these calcaneal tuberosities in the IAT group.
- The optimal rotation angle was solved during the optimization.

The counterclockwise \(\theta\)-angled rotation of the observed curvature can be written as:

\[
\text{RV}_\theta = 
\begin{bmatrix}
\text{RV}_{\theta x} \\
\text{RV}_{\theta y}
\end{bmatrix}
=
\begin{bmatrix}
\cos \theta & -\sin \theta \\
\sin \theta & \cos \theta
\end{bmatrix}
\begin{bmatrix}
x_i \\
y_i
\end{bmatrix}
=
\begin{bmatrix}
x_i \cos \theta - y_i \sin \theta \\
x_i \sin \theta + y_i \cos \theta
\end{bmatrix}
\]

where:

- \(\text{RV}_\theta\) represents the rotated enlarged contour of the calcaneal tuberosity with x-coordinates \(\text{RV}_{\theta x}\) and y-coordinates \(\text{RV}_{\theta y}\).
- \(x_i\) and \(y_i\) are the coordinates for the original enlarged tuberosities.

### Sum of Squares Error (SSE)

The rotation loss with respect to \(\theta\) is quantified as a sum of square loss \(SSE(\theta)\), which measures the similarity between the \(\theta\)-rotated curvature and the standard circle:

\[
SSE(\theta) = \frac{1}{N} \sum_{i=1}^{N} \sqrt{(\text{SC}_{xi} - \text{RV}_{\theta xi})^2 + (\text{SC}_{yi} - \text{RV}_{\theta yi})^2}
\]

where:

- \(\text{SC}_{xi}, \text{SC}_{yi}\) are the x and y coordinates of the Standard Circle.
- \(\text{RV}_{\theta xi}, \text{RV}_{\theta yi}\) are the x and y coordinates of the rotated enlarged contour.
- \(N = 54\) (54 points in total from point 37 to point 90 used to depict the enlarged contour).

### Finding the Optimal Rotation Angle

The optimal rotation angle can be found at the minima of the rotation loss with respect to the rotation angle, or when:

\[
\frac{\partial SSE(\theta)}{\partial \theta} = 0
\]

### Theoretical Basis for PAIA and Zadek Osteotomy

Since the ideal normal contour and the enlarged contour of the calcaneal tuberosity share the same center of rotation at the weight-bearing point of the calcaneus, the size of the PAIA would match the exact size of the Zadek osteotomy if the apex of the osteotomy is chosen at the weight-bearing point of the calcaneus.
