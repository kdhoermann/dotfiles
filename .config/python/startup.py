# Enable tab completion
try:
    import readline

    readline.parse_and_bind("tab: complete")
except ImportError:
    pass

# Rich REPL
try:
    from rich import pretty
    pretty.install()
except ImportError:
    pass
