// javascript-inertia/types.ts

export type InertiaProps = {
  errors: Record<string, string>;
} & Record<string, unknown>;

export type InertiaPage = {
  component: string;
  props: InertiaProps;
  url: string;
  version: string;
  encryptHistory?: boolean;
  clearHistory?: boolean;
};

