import { Grid, Button, Typography } from "@mui/material";
import DisplayProject from "../DisplayProject/DisplayProject";
import ListProjects from "../ListProjects/ListProjects";
import { useState, useEffect } from "react";
import { IconLink, Item } from "../Helpers/Helpers";
import { Project } from "../Types/Types";
import AdminPanelSettingsOutlinedIcon from "@mui/icons-material/AdminPanelSettingsOutlined";
import PersonOutlineOutlinedIcon from "@mui/icons-material/PersonOutlineOutlined";
import CreateProject from "../CreateProject/CreateProject";
import {
  CONFIG_MAX_PROJECTS,
  CONFIG_ADMIN_PAGE_TITLE,
  CONFIG_USER_PAGE_TITLE,
  API_URL,
} from "../../configs/configs";
import axios from "axios";
import { v4 as uuidv4 } from "uuid";

const ProjectContent = (props: { isAdmin: boolean }) => {
  // Data State
  const [projectList, setProjectList] = useState<Project[]>([]);
  const [isLoaded, setIsLoaded] = useState(false);

  // UI State
  const [selectedProject, setSelectedProject] = useState<string | null>(null);
  const [isNewProject, setisNewProject] = useState(false);
  const [textFieldValue, setTextFieldValue] = useState("---");

  //Handlers
  const handleCancelCreation = () => {
    setisNewProject(false);
  };

  const handleSaveProject = async (newProject: Project) => {
    try {
      await createProjectFromAPI(newProject);
      setProjectList((prevProjectList) => [...prevProjectList, newProject]);
      setisNewProject(false);
    } catch (error) {
      console.error("Error creating project:", error);
    }
  };

  const handleDeleteProject = async (projectId: string) => {
    try {
      const projectListCopy: Project[] = JSON.parse(JSON.stringify(projectList));
      await deleteProjectFromAPI(projectId);
      const updatedProjectList = projectListCopy.filter(
        (project) => project.id !== projectId
      );
      setProjectList(updatedProjectList);
    } catch (error) {
      console.error("Error creating project:", error);
    }
  };

  //API REQUESTS

  const fetchProjectsFromAPI = async () => {
    try {
      const response = await axios.get(API_URL + "/projects");
      return response.data;
    } catch (error) {
      console.error("Error fetching projects:", error);
      return [];
    }
  };

  const deleteProjectFromAPI = async (projectId: string) => {
    try {
      await axios.delete(API_URL + "/projects/" + projectId);
    } catch (error) {
      console.error("Error deleting projects:", error);
    }
  };

  const createProjectFromAPI = async (project: Project) => {
    try {
      await axios.post(API_URL + "/projects", project);
    } catch (error) {
      console.error("Error creating project:", error);
    }
  };

  useEffect(() => {
    const fetchData = async () => {
      try {
        const projects = await fetchProjectsFromAPI();
        setProjectList(projects);
        setIsLoaded(true);
      } catch (error) {
        console.error("Error fetching data:", error);
        setIsLoaded(true); // Set isLoaded to true even if there's an error
      }
    };

    fetchData();
  }, []);

  return (
    <>
      {/* Navigation Bar */}
      <Grid container spacing={2}>
        <Grid item xs={4}>
          {props.isAdmin ? (
            <AdminPanelSettingsOutlinedIcon fontSize="large" />
          ) : (
            <PersonOutlineOutlinedIcon fontSize="large" />
          )}
        </Grid>
        <Grid item xs={4} justifyContent="center">
          <Typography align="center" variant="h5">
            {props.isAdmin ? CONFIG_ADMIN_PAGE_TITLE : CONFIG_USER_PAGE_TITLE}
          </Typography>
        </Grid>
        <Grid item xs={4}>
          <IconLink />
        </Grid>
      </Grid>
      {/* Render the components only if not creating a new project */}
      {!isNewProject ? (
        <>
          <Grid container spacing={1}>
            {/* Project Selector */}
            {!isNewProject ? (
              <Grid item xs={4}>
                <Item>
                  <ListProjects
                    selectedProject={selectedProject}
                    setSelectedProject={setSelectedProject}
                    setTextFieldValue={setTextFieldValue}
                    projects={projectList}
                  />
                </Item>
                {!isNewProject ? (
                  <Item>
                    {props.isAdmin ? (
                      projectList.length < CONFIG_MAX_PROJECTS ? (
                        <>
                          <Button
                            variant="contained"
                            onClick={() => {
                              setisNewProject(true);
                            }}
                          >
                            Create New Project
                          </Button>
                          <Typography variant="body2" p={3}>
                            Maximum Number of Projects allowed: {CONFIG_MAX_PROJECTS} | Total Projects Created: {projectList.length}
                          </Typography>
                        </>
                      ) : (
                        <Typography variant="body2" p={3}>
                          You've reached the Maximum Number of Projects allowed: {CONFIG_MAX_PROJECTS}. If you want to create a new one, make sure you delete one from the list.
                        </Typography>
                      )
                    ) : null}
                  </Item>
                ) : null}
              </Grid>
            ) : null}
            {/* Project Details */}
            <Grid item xs={8}>
              <Item>
                {isLoaded && !isNewProject && selectedProject !== null ? (
                  <DisplayProject
                    selectedProject={projectList.find(
                      (project) => project.id === selectedProject
                    )}
                    isAdmin={props.isAdmin}
                    onDeleteProject={handleDeleteProject}
                  />
                ) : null}
              </Item>
            </Grid>
          </Grid>
        </>
      ) : null}
      {isNewProject ? (
        <>
          <Grid container spacing={1}>
            <Grid item xs={2}></Grid>
            <Grid item xs={8}>
              <Item>
                <CreateProject
                  onCancel={handleCancelCreation}
                  onSave={handleSaveProject}
                  new_id={uuidv4()}
                />
              </Item>
            </Grid>
            <Grid item xs={2}></Grid>
          </Grid>
        </>
      ) : null}
    </>
  );
};

export default ProjectContent;
