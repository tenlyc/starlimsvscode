### Contributing

We welcome contributions to the STARLIMS VS Code Extension! Here's how to get started:

#### Setup Development Environment

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/starlimsvscode.git
   cd starlimsvscode
   ```
3. **Install dependencies**:
   ```bash
   npm install
   ```

#### Development Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b my-new-feature
   ```

2. **Make your changes** following the project's coding standards

3. **Run linter** to check code quality:
   ```bash
   npm run lint
   ```

4. **Compile and test** your changes:
   ```bash
   npm run compile
   ```

5. **Test the extension**:
   - Press F5 in VS Code to open the Extension Development Host
   - Test your changes in the development environment

6. **Commit your changes**:
   ```bash
   git commit -am 'Add some feature'
   ```

7. **Push to your fork**:
   ```bash
   git push origin my-new-feature
   ```

8. **Submit a pull request** to the main repository

#### Build Commands

- `npm run lint` - Check code quality with ESLint
- `npm run compile` - Compile TypeScript with webpack (development mode)
- `npm run package` - Build for production with source maps
- `npm run build` - Full build including backend package and VSIX creation
- `npm run test` - Run tests (requires VS Code)

#### Code Style

- Follow TypeScript and ESLint best practices
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and concise

#### Packaging and Publishing

For detailed information about packaging and publishing releases, see [PACKAGING.md](PACKAGING.md).

#### Questions?

If you have any questions or need help, please open an issue on GitHub.
