# Learning Sparse High Dimensional Filters

This is the code accompanying the following **CVPR 2016** publication:

--------

**Learning sparse high dimensional filters :
Image Filtering, Dense CRFs and Bilateral Neural Networks**.

--------

This is developed and maintained by
[Martin Kiefel](https://ps.is.tuebingen.mpg.de/person/mkiefel),
[Varun Jampani](https://ps.is.tuebingen.mpg.de/person/vjampani),
[Raffi Enficiaud](https://is.tuebingen.mpg.de/software-workshop) and
[Peter V. Gehler](https://ps.is.tuebingen.mpg.de/person/pgehler).

Please visit the project website [http://bilateralnn.is.tue.mpg.de](http://bilateralnn.is.tue.mpg.de) for more details about the paper and overall methodology.

## Installation

The code provided in this repository relies on the same installation procedure as the one from [Caffe](http://caffe.berkeleyvision.org/).
Before you start with the `BilateralNN` code, please install all the requirements of Caffe by following the instructions from [this page](http://caffe.berkeleyvision.org/installation.html) first.
You will then be able to build Caffe with our code.

## Integration into Caffe

There are mainly two ways for integrating the additional layers provided by our library into Caffe:

* Dowloading a fresh clone of Caffe and patching it with our source files, so that you will be able to test the code with minimal effort
* Patching an existing copy of Caffe, so that you can integrate our code with your own development on Caffe.

### Downloading and Patching

This can be done just by the following commands:
```
cd $bilateralNN
mkdir build
cd build
cmake ..
```

This will configure the project, you may then run:

* for building the project
  ```
  make -j
  ```
  This will clone a Caffe version from the main Caffe repository into the `build` folder and compiles together with our newly added layers.
* for running the tests, including the ones of the BilateralNN:
  ```
  make -j runtest
  ```

  (this follows the same commands as for Caffe)

**Notes**

* Our code has been tested with revision `a1c81aca641e5b16f3e2007be07dfdedc072606e` of Caffe, and this
is the version that is cloned. You may change the version by passing the option `CAFFE_VERSION` on the command line of
`cmake`:

        cmake -DCAFFE_VERSION=some_hash_or_tag ..

such as `cmake -DCAFFE_VERSION=HEAD ..`.

* If you want to use your fork instead of the original Caffe repository, you may provide the option `CAFFE_REPOSITORY` on the `cmake` command line (it works exactly as for `CAFFE_VERSION`).
* Any additional command line argument you pass to `cmake` will be forwarded to Caffe, except for those
  used directly by our code:

      cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DBOOST_ROOT=../osx/boost_1_60_0/
        -DBoost_ADDITIONAL_VERSIONS="1.60\;1.60.0" ..

### Patching an existing Caffe version

#### Automatic CMAKE way
You may patch an existing version of Caffe by providing the `CAFFE_SRC` on the command line
```
cd $bilateralNN
mkdir build
cd build
cmake -DCAFFE_SRC=/your/caffe/local/copy ..
```

This will add the files of the BilateralNN to the source files of the existing Caffe copy, but **will also
overwrite caffe.proto** (a backup is made in the same folder).
The command will also create a build folder local to the BilateralNN repository (inside the `build` folder on the previous example): you may use this one
or use any previous one, Caffe should automatically use the sources of the BilateralNN.

#### Manual way
The above patching that is performed by `cmake` is rather a copying of the files from the folder of the `bilateralNN` to the
corresponding folders of Caffe. Caffe will then add the new files into the project.

Alternatively, you can manually copy all but `caffe.proto` source files in `bilateralNN` folder to the corresponding locations in your Caffe repository. Then, for merging the `caffe.proto` file of `bilateralNN` to your version of the `caffe.proto`:

1. the copy the lines 382-383 and 854-922 in `caffe.proto` to the corresponding `caffe.proto` file in the destination Caffe repository.
1. Change the parameter IDs for `PermutohedralParameter` and `PixelFeatureParameter` based on the next available `LayerParameter` ID in your Caffe.

## Example Usage
Examples are given in the folder `$bilateralNN/bilateralnn_code/examples`. Those examples rely on the Python extensions of Caffe.
You would find on [http://bilateralnn.is.tue.mpg.de](http://bilateralnn.is.tue.mpg.de)
a detailed description of the layer usage and an example.

## Citations

Please consider citing the following papers if you make use of this work and/or the corresponding code:

```
@inproceedings{jampani:cvpr:2016,
	title = {Learning Sparse High Dimensional Filters: Image Filtering, Dense CRFs and Bilateral Neural Networks},
	author = {Jampani, Varun and Kiefel, Martin and Gehler, Peter V.},
	booktitle = { IEEE Conf. on Computer Vision and Pattern Recognition (CVPR)},
	month = jun,
	year = {2016}
}
```
```
@article{kiefel:iclr:2015,
  title={Permutohedral Lattice CNNs},
  author={Kiefel, Martin and Jampani, Varun and Gehler, Peter V.},
  booktitle={International Conference on Learning Representations Workshop},
  month = May,
  year={2015}
}
```
