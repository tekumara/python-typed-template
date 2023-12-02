import sys


def main(args: list[str] = sys.argv[1:]) -> None:
    print(f"hello {args[0]}!")


if __name__ == "__main__":
    main()
