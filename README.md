#Lsyncd

[![Build Status](https://travis-ci.org/spjmurray/puppet-lsyncd.png?branch=master)](https://travis-ci.org/spjmurray/puppet-lsyncd)

####Table Of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Usage](#usage)
4. [Limitations](#limitations)

##Overview

Deploys lsyncd and one or many processes

###Module Description

The main module does a basic installation of lsyncd components and directories.
A 'process' define is responsible for creating configuration and running an
lsyncd process under a specific user.  As this is a define it allows multiple
lsyncd processes to run concurrently and as different users.

### Usage

```puppet
include ::lsyncd

lsyncd::process { 'puppet':
  config => template('path/to/

```
##Limitations

1. Ubuntu only
