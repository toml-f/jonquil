:sd_hide_title: true

Jonquil
=======

.. image:: _static/header.svg
   :alt: TOML Fortran
   :width: 75%

.. image:: https://img.shields.io/badge/license-MIT%7CApache%202.0-blue
   :alt: License
   :target: https://opensource.org/licenses/Apache-2.0

.. image:: https://img.shields.io/github/v/release/toml-f/jonquil
   :alt: Version
   :target: https://github.com/toml-f/jonquil/releases/latest

.. image:: https://github.com/toml-f/jonquil/workflows/CI/badge.svg
   :alt: Continuous Integration
   :target: https://github.com/toml-f/jonquil/actions

.. image:: https://github.com/toml-f/jonquil/workflows/docs/badge.svg
   :alt: API docs
   :target: https://toml-f.github.io/jonquil

.. image:: https://readthedocs.org/projects/jonquil/badge/?version=latest
   :target: https://jonquil.readthedocs.io
   :alt: Documentation Status

.. image:: https://codecov.io/gh/toml-f/jonquil/branch/main/graph/badge.svg
   :alt: Coverage
   :target: https://codecov.io/gh/toml-f/jonquil

This projects provides a JSON parser and writer based on and compatible with the `TOML Fortran <https://toml-f.readthedocs.io>`__ library.
The origin of this library was the idea to make a TOML parser speak JSON by implementing a JSON lexer on top of TOML Fortran's parser architecture as well as creating a new JSON serializer for visiting TOML data structures.
It turned out to work good enough, so here we are with yet another JSON library.

The JSON parser of Jonquil reaches similar performance as the established `JSON Fortran <https://github.com/jacobwilliams/json-fortran>`__.
However, the main goal of Jonquil is not to provide the most conforming JSON library, but to implement a seamless compatibility layer to enable TOML Fortran libraries to consume JSON as well as the other way round to allow JSON consuming libraries to try out TOML.
