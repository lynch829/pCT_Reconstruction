pCT Image Reconstruction Program
=========================================================================
This program accepts information about the proton tracks and energy measurements acquired from various gantry angles and:

(1) Removes irrelevant and statistical outliers from data set
(2) Performs hull-detection
(3) Performs MLP
(4) Reconstructs a pCT image via iterative projection methods

Note: Currently ART is the only image reconstruction algorithm that has been implemented and it is performed completely sequentially on the host (i.e. no GPU/CPU parallelism exploited).  Total variation and superiorization is also not currently implemented.  The remainder of the program (except for MLP) makes use of the GPU with nearly all calculations performed on the GPU and the host used only for allocating/destroying GPU memory for reconstruction data, transferring data and results to/from the GPU, and configuring/launching GPU kernels.  Specifying the appropriate input data and execution configuration, parameters, and settings is specified with a config file and the location of the desired config file is specified as a command line argument when executing the program (i.e. ./pct_reconstruction [.cfg file address]).
