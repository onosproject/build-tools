import setuptools
with open("README.md", "r") as fh:
    long_description = fh.read()
setuptools.setup(
     name='boilerplate',
     version='0.1',
     scripts=['boilerplate'] ,
     author="Andrea Campanella",
     author_email="andrea@opennetworking.org",
     description="License check tool",
     long_description=long_description,
   long_description_content_type="text/markdown",
     url="https://github.com/onosproject/build-tools",
     packages=setuptools.find_packages(),
     classifiers=[
         "Programming Language :: Python :: 3",
         "License :: OSI Approved :: APACHE 2.0 License",
         "Operating System :: OS Independent",
     ],
 )