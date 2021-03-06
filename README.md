=========================================================================
Proton Computed Tomography (pCT) Preprocessing/Image Reconstruction Program
=========================================================================

####This program expects proton tracker coordinate and Water Equivalent Path Length (WEPL) measurements acquired from various gantry angles and:

-------------------------------------------------------------------------
**Phase 1:**
-------------------------------------------------------------------------
**(1)** Parse command line arguments, use different *config* file if path argument given, generate modified *config* file if `key/value` pairs passed as arguments.  
**(2)** Parse default, modified, or specified *config* file (depending on results **(1)**) and set internal variables/options I/O directories, file names, and file paths.  
**(3)** Transfer instance of `configurations` **struct** (`parameters`) whose members correspond to program parameters/options to GPU's global memory to establish persistent access to these throughout program execution by passing its global memory address instead of individually by value to each kernel.  
**(4)** Determine if **BOTH** the entry **AND** the exit paths of each proton intersect reconstruction volume and, thus, pass through it.  
**(5)** For protons that pass through reconstruction volume, accumulate entry/exit coordinates/angles of this intersection and their WEPL, gantry angle, and bin number.  
**(6)** Perform statistical analysis of each bin (mean/std dev) and remove histories with WEPL or xy/xz angle greater than 3 std devs from mean.  
**(7)** Perform hull-detection  (SC, MSC, SM, and/or FBP).  
**(8)** Perform any image filtering (2D/3D median/average) or data processing (WEPL distributions, radiographs, etc.) specified in *config* file.  
**(9)** Write the data/images specified in *config* file but not required for reconstruction to disk.  
**(10)** Choose the hull and perform the method for constructing the initial iterate specified in *config* file and write these to `hull.txt` and `x_0.txt`, respectively.  
**(11)** Using specified hull, determine if **BOTH** the entry **AND** the exit paths of each proton intersect hull and, thus, pass through it.  
**(12)** For protons that pass through the hull, determine their entry/exit coordinates/angles and update the values found in `(5)` to these, record their entry *x*/*y*/*z* voxel, and remove all data found in `(5)` for protons that do not pass through hull.  
**(13)** For the data accumulated in `(12)`, write the WEPL data to `WEPL.bin` and the entry/exit coordinate/angles, entry *x*/*y*/*z* voxel, bin number, and gantry angle to to `histories.bin`.   
**(14)** Using entry/exit data from `(12)`, calculate the MLP and write intersected voxels along paths to `MLP.bin`.  

-------------------------------------------------------------------------
**Phase 2:**
-------------------------------------------------------------------------
**(1)** Calculate the largest prime number (*P*) less than *1/4*th of the total # of histories (*N*).  
(2) Generate a sequence of numbers beginning with 0 successive numbers      by successively adding *P* to the previous number erer wer wer

such that the difference between successive numbers is this prime number *P* modulo N, i.e., *n(i+1) - n(i) = P mod(N)* or  *n(i+1) = n(i) + P mod(N)*.  Beginning with array/vector index 0, generate 

Beginning with 0, generate a sequence of numbers {n1, n2, n3, ..., nN} with the next number being the modulo N result of the sum of the previous number  n(i+1) = n(i) + P mod(N)

by adding this prime number to the previous number


taking the modulo N result of the sum of the previous number and this prime number.  

If we begin with 1 and repeatedly add this prime number modulo *N* it will generate a sequence of numbers in which every number 1-N will appear exactly once before any number is repeated.  If we use this sequence of #s to select the order in which we use histories in reconstruction instead of applying them sequentially, we will still use each history once per iteration but successive histories will now be approximately orthogonal, thereby improving convergence since orthogonal histories have no voxels in common and thus provide more information than histories with little angular separation which often provide redundant information when their paths have 1 or more voxels in common.  This ordering will not guarantee that successive histories are perfectly orthogonal, but it dramatically increases the chances that successive histories do not share any common voxels and therefore maximizes the amount of new information added by successive histories.  
  
**(2)** Perform image reconstruction using the iterative projection method specified in *config* file.  
**(3)** After each iteration, write image to disk as `x_k.txt`, where *k* denotes this is the reconstructed image `x` after the *k*th iteration.  
**(4)** After each iteration, apply 2D/3D median/average filter with radius *r* if specified in *config* file, writing the result of this to disk as well as `x_k_xxx_xx_rx`, where `xxx` is either *med* or *avg*, `xx` is either *2D* or *3D*, and the last `x` denotes the filter width *w*.  
**(5)** After the last iteration, write final reconstructed image to disk as `x.txt`.  
**(6)** If specified in *config* file, apply 2D/3D median/average filter with radius *r*, writing the result of this to disk as well as `x_xxx_xx_rx`, where `xxx` is either *med* or *avg*, `xx` is either *2D* or *3D*, and the last `x` denotes the filter width *w*.  

Currently implemented iterative projection method algorithms are ART, DROP, and 2 variations of a Robust approach to DROP still in development (total variation/superiorization has not been implemented yet).  The data/task parallelism is inherent in nearly every aspect of preprocessing and reconstruction and has been exploited (except for MLP and image reconstruction) using GPGPU programming (CUDA).  The host is primarily used only for allocating/freeing GPU memory,  transferring data to/from the GPU, and configuring/launching GPU kernels.  All options/parameters affecting program behavior are specified via `key/value` pairs in configuration file `settings.cfg` and if this is not located in the expected default location, its path can be passed as a command line argument.  With this approach, since changing parameters does not modify the program's source code, it does not need to be recompiled each time an option/parameter is changed and the program can be ran by simply launching its `.exe` file unless the `.cfg` file is not in its default location.  To simplify the implementation of this approach, the program adheres to and enforces the pCT data file/folder naming and organizational scheme for expected location of input data and creation of folders where output data is written to disk (includes some flexibility in path specifications if this is either not possible or not desired but file naming conventions are strictly enforced).

For typical (single execution) reconstructions, the `settings.cfg` file is used to specify the desired parameter values and control the program's behavior/options.  By default, this file is in the same directory as the `projection_xxx` data, but if it is not in this default location or another *config* file is desired instead, the path to this *config* file can be passed as an argument to the program when executed from the command line.  To make it possible to run multiple reconstructions consecutively (i.e. batch execution) with different values for 1 or more parameters/options, the new `key/value` pairs desired can be passed to the program as a series of arguments when it is executed from the command line.  This will save a copy of the *config* file in the directory where the preprocessing data will be written but with the value of these keys overwritten with their new values.  This will not affect the existing *config* file since it will be needed for subsequent reconstructions in the batch, but the new *config* file will be written to the directory containing the resulting preprocessed data and/or reconstructed images, thereby providing a record of the parameters/options used in generating it.  Similarly, if the path to a *config* file is passed to the program as a command line argument, a copy of it will be written to the directory containing the resulting preprocessed data regardless of whether its values were changed via `key/value` pair command line arguments or not.  In other words, a *config* file is always written to the directory containing the resulting preprocessed data unless there is a *config* file in the directory containing the projection data and none of its values were changed.  Thus, if the directory containing the preprocessed data does not contain a *config* file, then the *config* file in the projection data directory was used.    

Since modifications to the *config* file are always specified as `key/value` pairs, the optional path to a *config* file in a non-default location is always passed as the last command line argument so it can easily be identified.  Regardless of how many `key/value` pair changes are made, there will always be an odd number of command line arguments passed if the path to the *config* file is passed and even number otherwise.  Thus, but counting the number of command line arguments passed to the program, it is easy to determine **(1)** how many `key/value` pairs are to be modified and **(2)** if the path to a specific *config* file has been specified.  The series of commands to execute the program and pass these optional parameters is as follows:

#####`nvcc -gencode arch=compute_35,code=sm_35 -O3 pCT_Reconstruction_Data_Segments_Blake.cu -o jpertwee.out`
#####`./pCT_Reconstruction[key 1][val 1][key 2][val 2]...[key n][val n][cfg path]`  

Program execution begins by parsing the program's command line arguments and determines how many `key/value` pairs are to be modified and if the *config* file containing the program's parameters/options is to be read from the default location or from a user defined location.  All command line arguments are optional, none are required, in which case the program reads the *config* file from its default location in the projection data directory and no changes are made to it.  If the *config* file is to be changed, the new *config* file is generated and written to disk first.  If a *config* file from a non-default location is to be used, it is first copied from its existing location into the directory where the preprocessed data will be written.  Once this has been been finished, the appropriate *config* file is read and parsed and its `key/value` pairs used to set the corresponding members of the global instance of the **struct** `configurations` named `parameters`.  

After reading the entire *config* file and setting the appropriate parameters/options, internal variables dependent on these configurations are then set.  Once all options, parameters, and variables are set, then the input/output directories, file names, and file paths are established.  The *config* file has `key/value` pairs for specifying whether existing directories should or should not be overwritten, so if overwriting is not permitted, then existing directories are renamed by appending `_i` beginning with *i = 1* until a unique directory name has been achieved.  If overwriting is permitted, then directory names are not changed and any existing data in these directories may be overwritten since file names do not change.  Once directories and file name are all defined, each file is combined with the directory where it should be written so this complete path can be passed to I/O file operation functions.  

However, there are a few images whose file names can change, namely those that result from filtering as the size of the filter neighbourhood is reflected in their file name.  For example, a 2D median filter with filter width 7 (radius 3) applied to the FBP image is named `FBP_med_2D_r7.txt`.  For `FBP`, `hull`, `x_0`, `x_k`, and `x`, the *config* file has `key/value` pairs specifying the radii to use when applying median filter and average filters and it is permissible to generate 1 or more of these during preprocessing/reconstruction.  However, although there is the option to generate and save each of these during preprocessing, the *config* file is used to specify which is to be used as the hull (`hull_h`) and the initial iterate (`x_h`), with `x_h` being updated after each iteration of reconstruction; i.e., each iteration of reconstruction is stored in the same `x_h` global variable and the only way each iteration is known after reconstruction is because the initial iterate is written to disk as `x_0.txt` and after the *k*th iteration it is saved as `x_k.txt`.





