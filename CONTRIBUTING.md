# Contributing to Halifax Foodie

Thank you for your interest in contributing to Halifax Foodie! We welcome contributions from the community.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)

## 📜 Code of Conduct

By participating in this project, you agree to:
- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism gracefully
- Focus on what's best for the community

## 🚀 Getting Started

### Prerequisites

Ensure you have installed:
- Node.js 14+
- Python 3.9+
- AWS CLI configured
- Git

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
```bash
git clone https://github.com/your-username/HalifaxFoodie.git
cd HalifaxFoodie
```

3. Add upstream remote:
```bash
git remote add upstream https://github.com/original-org/HalifaxFoodie.git
```

### Setup Development Environment

**Frontend**:
```bash
cd frontend
npm install
npm start
```

**Backend**: See [backend/README.md](backend/README.md) for specific setup instructions.

## 🤝 How to Contribute

### Types of Contributions

We welcome:
- **Bug fixes**: Fix issues in existing code
- **New features**: Add new functionality
- **Documentation**: Improve or add documentation
- **Tests**: Add or improve test coverage
- **Code refactoring**: Improve code quality
- **UI/UX improvements**: Enhance user interface

## 🔄 Development Workflow

1. **Create a branch**:
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-description
```

Branch naming conventions:
- `feature/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `docs/documentation-update` - Documentation changes
- `refactor/code-improvement` - Code refactoring
- `test/test-description` - Test additions/improvements

2. **Make your changes**:
- Write clear, concise code
- Follow existing code style
- Add comments for complex logic
- Update documentation as needed

3. **Test your changes**:
```bash
# Frontend
cd frontend
npm test

# Backend (example)
cd backend/Authentication
npm test
```

4. **Commit your changes**:
```bash
git add .
git commit -m "feat: add user profile page"
```

Commit message format:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

5. **Push to your fork**:
```bash
git push origin feature/your-feature-name
```

6. **Create a Pull Request** on GitHub

## 💻 Coding Standards

### JavaScript/React

- Use ES6+ syntax
- Use functional components with hooks
- Follow Airbnb JavaScript Style Guide
- Use meaningful variable and function names
- Keep functions small and focused
- Add PropTypes for component props

Example:
```javascript
import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';

const UserProfile = ({ userId }) => {
  const [user, setUser] = useState(null);
  
  useEffect(() => {
    fetchUser(userId);
  }, [userId]);
  
  const fetchUser = async (id) => {
    // Implementation
  };
  
  return (
    <div>{/* Component JSX */}</div>
  );
};

UserProfile.propTypes = {
  userId: PropTypes.string.isRequired,
};

export default UserProfile;
```

### Python

- Follow PEP 8 style guide
- Use type hints where appropriate
- Write docstrings for functions and classes
- Keep functions focused and testable

Example:
```python
from typing import Dict, List

def process_reviews(reviews: List[Dict]) -> Dict:
    """
    Process restaurant reviews and extract insights.
    
    Args:
        reviews: List of review dictionaries
        
    Returns:
        Dictionary containing processed insights
    """
    # Implementation
    return processed_data
```

### CSS

- Use BEM naming convention
- Keep selectors specific but not overly complex
- Use CSS variables for colors and common values
- Maintain consistent spacing

## 🧪 Testing Guidelines

### Frontend Tests

- Write unit tests for components
- Write integration tests for user flows
- Aim for >80% code coverage

```javascript
import { render, screen, fireEvent } from '@testing-library/react';
import Login from './Login';

test('renders login form', () => {
  render(<Login />);
  expect(screen.getByText(/login/i)).toBeInTheDocument();
});
```

### Backend Tests

- Write unit tests for Lambda handlers
- Mock AWS services using moto or similar
- Test error handling

```python
import pytest
from lambda_function import lambda_handler

def test_lambda_handler():
    event = {'body': json.dumps({'test': 'data'})}
    context = {}
    
    response = lambda_handler(event, context)
    
    assert response['statusCode'] == 200
```

## 📝 Pull Request Process

1. **Update documentation**: Ensure README and other docs reflect your changes

2. **Add tests**: All new features must include tests

3. **Run tests locally**: Ensure all tests pass before submitting

4. **Update CHANGELOG**: Add a brief description of your changes

5. **Submit PR with description**:
   - What does this PR do?
   - Why is this change needed?
   - How has it been tested?
   - Screenshots (for UI changes)

6. **Respond to feedback**: Address review comments promptly

7. **Squash commits**: Before merging, squash commits into logical units

### PR Title Format

```
[Type] Brief description

Examples:
[Feature] Add user profile page
[Fix] Resolve authentication timeout issue
[Docs] Update deployment instructions
```

### PR Description Template

```markdown
## Description
Brief description of changes

## Motivation
Why is this change necessary?

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
How was this tested?

## Screenshots (if applicable)

## Checklist
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Code follows style guidelines
- [ ] No console.log statements
- [ ] Reviewed my own code
```

## 🐛 Reporting Issues

### Before Submitting an Issue

1. Check if the issue already exists
2. Verify you're using the latest version
3. Collect relevant information

### Issue Template

```markdown
**Description**
Clear description of the issue

**Steps to Reproduce**
1. Step 1
2. Step 2
3. Step 3

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Screenshots**
If applicable

**Environment**
- OS: [e.g., macOS 13.0]
- Browser: [e.g., Chrome 120]
- Node version: [e.g., 18.0.0]

**Additional Context**
Any other relevant information
```

## 🎨 UI/UX Contributions

- Follow Material Design principles
- Ensure responsive design (mobile, tablet, desktop)
- Maintain accessibility (WCAG 2.1 AA)
- Test on multiple browsers
- Consider dark mode if applicable

## 📚 Documentation

- Use clear, concise language
- Include code examples
- Add screenshots or diagrams
- Keep README files up to date
- Document API changes

## 🔐 Security

- Never commit sensitive data (API keys, passwords)
- Use environment variables for configuration
- Report security vulnerabilities privately
- Follow AWS security best practices

## ❓ Questions?

- Open a discussion on GitHub
- Check existing documentation
- Contact the maintainers

## 🙏 Thank You!

Your contributions make Halifax Foodie better for everyone. We appreciate your time and effort!

---

**Happy Contributing! 🚀**
