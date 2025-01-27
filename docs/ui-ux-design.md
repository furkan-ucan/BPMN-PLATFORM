# BPM Platform - UI/UX Tasarım Dokümanı

## 1. Component Library

### 1.1 Temel Bileşenler
```typescript
// Button Component
interface ButtonProps {
  variant: 'primary' | 'secondary' | 'text';
  size: 'small' | 'medium' | 'large';
  disabled?: boolean;
  loading?: boolean;
  icon?: ReactNode;
  onClick?: () => void;
}

// Input Component
interface InputProps {
  type: 'text' | 'number' | 'email' | 'password';
  size: 'small' | 'medium' | 'large';
  error?: string;
  helperText?: string;
  prefix?: ReactNode;
  suffix?: ReactNode;
}

// Form Components
interface FormProps {
  layout: 'horizontal' | 'vertical';
  size: 'small' | 'medium' | 'large';
  labelWidth?: number;
  labelAlign?: 'left' | 'right';
}
```

### 1.2 Layout Bileşenleri
```typescript
// Grid System
interface GridProps {
  cols: number;
  gap: number;
  responsive?: {
    sm: number;
    md: number;
    lg: number;
  };
}

// Card Component
interface CardProps {
  title?: string;
  bordered?: boolean;
  hoverable?: boolean;
  loading?: boolean;
  extra?: ReactNode;
}
```

### 1.3 Data Display Bileşenleri
```typescript
// Table Component
interface TableProps<T> {
  columns: TableColumn[];
  data: T[];
  pagination?: PaginationProps;
  sorting?: SortingProps;
  filtering?: FilteringProps;
}

// Chart Components
interface ChartProps {
  type: 'line' | 'bar' | 'pie' | 'area';
  data: ChartData;
  options?: ChartOptions;
  responsive?: boolean;
}
```

## 2. Style Guide

### 2.1 Renk Paleti
```scss
// Primary Colors
$primary-50: #E3F2FD;
$primary-100: #BBDEFB;
$primary-500: #2196F3;
$primary-700: #1976D2;
$primary-900: #0D47A1;

// Secondary Colors
$secondary-50: #F3E5F5;
$secondary-100: #E1BEE7;
$secondary-500: #9C27B0;
$secondary-700: #7B1FA2;
$secondary-900: #4A148C;

// Neutral Colors
$neutral-50: #FAFAFA;
$neutral-100: #F5F5F5;
$neutral-500: #9E9E9E;
$neutral-700: #616161;
$neutral-900: #212121;

// Semantic Colors
$success: #4CAF50;
$warning: #FFC107;
$error: #F44336;
$info: #2196F3;
```

### 2.2 Tipografi
```scss
// Font Families
$font-primary: 'Inter', sans-serif;
$font-secondary: 'Roboto', sans-serif;
$font-mono: 'Fira Code', monospace;

// Font Sizes
$font-size-xs: 0.75rem;    // 12px
$font-size-sm: 0.875rem;   // 14px
$font-size-base: 1rem;     // 16px
$font-size-lg: 1.125rem;   // 18px
$font-size-xl: 1.25rem;    // 20px
$font-size-2xl: 1.5rem;    // 24px
$font-size-3xl: 1.875rem;  // 30px
$font-size-4xl: 2.25rem;   // 36px

// Line Heights
$line-height-tight: 1.25;
$line-height-normal: 1.5;
$line-height-relaxed: 1.75;
```

### 2.3 Spacing System
```scss
// Spacing Scale
$space-1: 0.25rem;   // 4px
$space-2: 0.5rem;    // 8px
$space-3: 0.75rem;   // 12px
$space-4: 1rem;      // 16px
$space-6: 1.5rem;    // 24px
$space-8: 2rem;      // 32px
$space-12: 3rem;     // 48px
$space-16: 4rem;     // 64px
```

## 3. Responsive Design

### 3.1 Breakpoint Sistemi
```scss
// Breakpoints
$breakpoints: (
  'sm': 640px,
  'md': 768px,
  'lg': 1024px,
  'xl': 1280px,
  '2xl': 1536px
);

// Media Queries
@mixin respond-to($breakpoint) {
  @if map-has-key($breakpoints, $breakpoint) {
    @media (min-width: map-get($breakpoints, $breakpoint)) {
      @content;
    }
  }
}
```

### 3.2 Grid Layout
```scss
.grid {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: $space-4;

  @include respond-to('sm') {
    grid-template-columns: repeat(6, 1fr);
  }

  @include respond-to('md') {
    grid-template-columns: repeat(8, 1fr);
  }

  @include respond-to('lg') {
    grid-template-columns: repeat(12, 1fr);
  }
}
```

## 4. Accessibility

### 4.1 ARIA Attributes
```typescript
// Accessible Button
const AccessibleButton = ({ label, onClick, disabled }) => (
  <button
    aria-label={label}
    aria-disabled={disabled}
    onClick={onClick}
    role="button"
  >
    {label}
  </button>
);

// Accessible Form Field
const AccessibleInput = ({ label, error, id }) => (
  <div role="group" aria-labelledby={`${id}-label`}>
    <label id={`${id}-label`}>{label}</label>
    <input
      id={id}
      aria-invalid={!!error}
      aria-describedby={error ? `${id}-error` : undefined}
    />
    {error && <span id={`${id}-error`} role="alert">{error}</span>}
  </div>
);
```

### 4.2 Keyboard Navigation
```typescript
const KeyboardNav = () => {
  const handleKeyPress = (event: KeyboardEvent) => {
    switch(event.key) {
      case 'Tab':
        // Focus next element
        break;
      case 'Enter':
        // Activate element
        break;
      case 'Escape':
        // Close modal/popup
        break;
    }
  };

  return (
    <div onKeyDown={handleKeyPress} tabIndex={0}>
      {/* Content */}
    </div>
  );
};
```

## 5. Animation ve Transitions

### 5.1 Motion System
```scss
// Duration
$duration-fast: 150ms;
$duration-normal: 300ms;
$duration-slow: 500ms;

// Easing
$ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
$ease-out: cubic-bezier(0, 0, 0.2, 1);
$ease-in: cubic-bezier(0.4, 0, 1, 1);

// Transitions
.fade-enter {
  opacity: 0;
  transform: translateY(10px);
}

.fade-enter-active {
  opacity: 1;
  transform: translateY(0);
  transition: opacity $duration-normal $ease-out,
              transform $duration-normal $ease-out;
}
```

## 6. Performance Optimization

### 6.1 Image Optimization
```typescript
const OptimizedImage = ({ src, alt, sizes }) => (
  <picture>
    <source
      media="(min-width: 1024px)"
      srcSet={`${src}-large.webp 1024w`}
      type="image/webp"
    />
    <source
      media="(min-width: 640px)"
      srcSet={`${src}-medium.webp 640w`}
      type="image/webp"
    />
    <img
      src={`${src}-small.jpg`}
      alt={alt}
      loading="lazy"
      sizes={sizes}
    />
  </picture>
);
```

### 6.2 Code Splitting
```typescript
// Lazy Loading Components
const LazyComponent = React.lazy(() => import('./HeavyComponent'));

const App = () => (
  <Suspense fallback={<Loading />}>
    <LazyComponent />
  </Suspense>
);
```

## 7. Error Handling

### 7.1 Error Boundaries
```typescript
class ErrorBoundary extends React.Component {
  state = { hasError: false, error: null };

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  render() {
    if (this.state.hasError) {
      return (
        <ErrorDisplay
          error={this.state.error}
          onRetry={() => this.setState({ hasError: false })}
        />
      );
    }

    return this.props.children;
  }
}
```

### 7.2 Loading States
```typescript
const LoadingState = ({ status, children }) => {
  switch (status) {
    case 'loading':
      return <Skeleton />;
    case 'error':
      return <ErrorMessage />;
    case 'empty':
      return <EmptyState />;
    case 'success':
      return children;
    default:
      return null;
  }
};
```