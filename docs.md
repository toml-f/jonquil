This is the API documentation for Jonquil, a JSON parser and serializer for Fortran built on top of [TOML Fortran](https://toml-f.github.io/toml-f/).

## Getting Started

The main entry point is the `jonquil` module, which re-exports all public APIs:

```fortran
use jonquil
```

### Key Procedures

- `json_load` / `json_loads` - Parse JSON from files or strings
- `json_dump` / `json_dumps` - Serialize data structures to JSON
- `get_value` / `set_value` - Access and modify values in JSON objects

### Key Types

- `json_object` - A JSON object (key-value mapping)
- `json_array` - A JSON array
- `json_value` - Base type for all JSON values
- `json_error` - Error information from parsing

For usage examples and tutorials, see the [TOML Fortran documentation](https://toml-f.readthedocs.io/en/latest/how-to/jonquil.html).