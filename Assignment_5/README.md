# Assignment_5 #
This is the 5th assignment in the dataprocessing course.

## Files
|File/Directory                 |Contains                               |  
|---                            |---                                    |
|config                         |the config file                        |
|workflow                       |all snakemake modules and scripts      |
|Hardware.txt                   |answers to the written questions about the amount of cores an threads in certain systems       |
|Code_review.txt                |answers to code review questions|

## Running the script
To run everything you will need to run the following command from the ``Assignment_5`` directory
(substitude {cores} with the amount of cores you wish to use):
``` 
snakemake --cores {cores}
```

To clean the output you can use: 
```
snakemake clean --cores {cores}
```

## Data paths
The data paths need to be specified in the  ``config.yaml`` file in under the config
directory. The data used for this assignment is the same data used for Assignment_2.

## Contact

* K. Notebomer
  * k.a.notebomer@st.hanze.nl