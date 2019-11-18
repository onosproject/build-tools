import setuptools

long_description = '''Python tool to check license compliance with
given template file for each file type according to it's extension ?'''

setuptools.setup(
     name='boilerplate',
     version='0.1',
     author="Andrea Campanella",
     author_email="andrea@opennetworking.org",
     description="License check tool",
     long_description=long_description,
     url="https://github.com/onosproject/build-tools",
     packages=setuptools.find_packages(),
     classifiers=[
         "Programming Language :: Python :: 3",
         "License :: APACHE 2.0 License",
         "Operating System :: OS Independent",
     ],
 )