export type Step = {
  id: number;
  description: string;
};

export type Project = {
  id: string;
  title: string;
  steps: Step[];
};
