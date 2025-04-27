import { Box, Typography, Button } from "@mui/material";
import { Project, Step } from "../Types/Types";

import { useEffect } from "react";

interface DisplayProjectProps {
  selectedProject: Project | undefined;
  isAdmin: boolean;
  onDeleteProject: (projectId: string) => void;
}

const DisplayProject = ({
  selectedProject,
  isAdmin,
  onDeleteProject,
}: DisplayProjectProps) => {
  useEffect(() => {});

  const handleDeleteProject = () => {
    if (selectedProject) {
      onDeleteProject(selectedProject.id);
    }
  };
  return (
    <Box border={1} borderColor="grey.300" p={1}>
      <Typography variant="h5" gutterBottom p={5}>
        {selectedProject?.title || "No Project Selected"}
      </Typography>

      {/*PROJECT STEPS SECTION*/}
      <Box border={1} borderColor="grey.300" p={2}>
        <Typography variant="h6" gutterBottom p={5}>
          Project Steps
        </Typography>
        {selectedProject?.steps.map((step: Step, index: number) => (
          <Typography key={step.id} variant="body1" p={1} align="left">
            Step {index + 1}. {step.description}
          </Typography>
        ))}
      </Box>
      {isAdmin && (
        <Box p={2}>
          <Button
            variant="contained"
            color="error"
            onClick={handleDeleteProject}
          >
            Delete Project
          </Button>
        </Box>
      )}
    </Box>
  );
};

export default DisplayProject;