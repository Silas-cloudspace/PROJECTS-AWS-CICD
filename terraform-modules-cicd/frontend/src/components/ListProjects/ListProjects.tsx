import { useEffect, useState } from "react";
import Radio from "@mui/material/Radio";
import RadioGroup from "@mui/material/RadioGroup";
import FormControlLabel from "@mui/material/FormControlLabel";
import FormControl from "@mui/material/FormControl";
import { Project } from "../Types/Types";
import { Typography } from "@mui/material";

interface ListProjectsProps {
  selectedProject: string | null;
  setSelectedProject: (projectId: string | null) => void;
  setTextFieldValue: (projectId: string) => void;
  projects: Project[] | [];
}

function ListProjects({
  selectedProject,
  setSelectedProject,
  setTextFieldValue,
  projects = [],
}: ListProjectsProps) {
  const [initialValue, setInitialValue] = useState<string>("");
  useEffect(() => {
    if (projects.length > 0 && selectedProject === null) {
      setSelectedProject(projects[0].id);
      setTextFieldValue(projects[0].id.toString());
      setInitialValue(projects[0].id.toString());
    }
  }, [projects, selectedProject, setSelectedProject, setTextFieldValue]);

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const projectId = event.target.value === "" ? null : event.target.value;
    setSelectedProject(projectId);
    setTextFieldValue(projectId !== null ? projectId.toString() : "");
  };

  const message = projects.length === 0 && (
    <p> There are no projects created yet</p>
  );

  return (
    <FormControl>
      <Typography variant="h6" gutterBottom p={2}>
        List of Projects
      </Typography>
      {message}
      <RadioGroup
        aria-labelledby="demo-controlled-radio-buttons-group"
        name="controlled-radio-buttons-group"
        value={selectedProject !== null ? selectedProject.toString() : ""}
        onChange={handleChange}
      >
        {projects
          ? projects.map((project) => {
              return (
                <FormControlLabel
                  key={project.id}
                  value={project.id.toString()}
                  control={<Radio />}
                  label={project.title}
                />
              );
            })
          : null}
      </RadioGroup>
    </FormControl>
  );
}

export default ListProjects;
