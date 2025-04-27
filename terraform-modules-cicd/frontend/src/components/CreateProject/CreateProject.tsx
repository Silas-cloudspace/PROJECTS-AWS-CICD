import { useState } from "react";
import { Button, TextField, Typography, Box } from "@mui/material";
import ProjectItem from "./ProjectItem";
import { Step, Project } from "../Types/Types";
import {
  CONFIG_MAX_STEPS,
} from "../../configs/configs";

interface CreateProjectProps {
  onCancel: () => void;
  onSave: (project: Project) => void;
  new_id: string;
}

const CreateProject = ({ onCancel, onSave, new_id }: CreateProjectProps) => {
  const [localTitle, setLocalTitle] = useState("");
  const [steps, setSteps] = useState<Step[]>([{ id: 1, description: "" }]);

  const MAX_STEPS = CONFIG_MAX_STEPS; // Define the maximum allowed steps

  // PROJECT TITLE SECTION
  const handleTitleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setLocalTitle(event.target.value);
  };

  // PROJECT STEPS SECTION

  const handleAddStep = () => {
    if (steps.length > 0) {
      const lastStep = steps[steps.length - 1];
      if (lastStep.description.trim() !== "") {
        if (steps.length < MAX_STEPS) {
          setSteps((prevSteps) => [
            ...prevSteps,
            { id: prevSteps.length + 1, description: "" },
          ]);
        } else {
          alert("You have reached the maximum number of steps allowed.");
        }
      } else {
        alert("Please complete the previous step before adding a new one.");
      }
    } else {
      // If the steps array is empty, add a new step directly
      setSteps([{ id: 1, description: "" }]);
    }
  };

  const handleDeleteStep = (id: number) => {
    setSteps((prevSteps) =>
      prevSteps
        .filter((step) => step.id !== id)
        .map((step, index) => ({ ...step, id: index + 1 }))
    );
  };

  const handleDescriptionChange = (id: number, newDescription: string) => {
    setSteps((prevSteps) =>
      prevSteps.map((step) =>
        step.id === id ? { ...step, description: newDescription } : step
      )
    );
  };

  // Buttons Functions
  // Save and Cancel buttons handlers
  const handleSave = () => {
    const project: Project = {
      id: new_id, // You can generate a unique ID based on your requirements
      title: localTitle,
      steps,
    };
    onSave(project);
  };

  const handleCancel = () => {
    onCancel();
  };

  //RETURN SECTION

  return (
    <Box border={1} borderColor="grey.300" p={2}>
      <Typography variant="h5" gutterBottom p={5}>
        New Project
      </Typography>
      {/*PROJECT TITLE SECTION*/}
      <Box mb={4} border={1} borderColor="grey.300" p={2}>
        <Typography variant="h6" gutterBottom p={1}>
          Title
        </Typography>
        <TextField
          id="outlined-basic"
          label={"Project Title"}
          variant="outlined"
          required
          placeholder={"Please insert the Project Title"}
          value={localTitle}
          onChange={handleTitleChange}
        />
      </Box>
      {/*PROJECT STEPS SECTION*/}
      <Box border={1} borderColor="grey.300" p={2}>
        <Typography variant="h6" gutterBottom p={5}>
          Project Steps
        </Typography>
        <Typography variant="body2">
          Maximum Project Steps allowed: {MAX_STEPS} | Total steps created: {steps.length}
        </Typography>
        {steps.map((item) => (
          <ProjectItem
            key={item.id}
            id={item.id}
            description={item.description}
            onDelete={handleDeleteStep}
            onDescriptionChange={handleDescriptionChange}
            itemType="Step"
          />
        ))}
        <Button onClick={handleAddStep}>ADD STEP</Button>
      </Box>
      {/* Save and Cancel buttons */}
      <Box mt={4} display="flex" justifyContent="center">
        <Button
          variant="contained"
          color="primary"
          onClick={handleSave}
          disabled={
            localTitle.trim() === "" ||
            steps.length === 0 ||
            steps[steps.length - 1].description.trim() === ""
          }
        >
          Save
        </Button>
        <Box mx={2} />
        <Button variant="outlined" color="secondary" onClick={handleCancel}>
          Cancel
        </Button>
      </Box>
    </Box>
  );
};

export default CreateProject;