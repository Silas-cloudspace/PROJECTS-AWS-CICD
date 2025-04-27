from fastapi import FastAPI, status
from typing import Union
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from typing import List
import uuid
import boto3

class Step(BaseModel):
    id: int
    description: str

class Project(BaseModel):
    id:str
    title: str
    steps: List[Step]

session = boto3.Session(
       region_name='SELECTED_REGION'
   )

dynamodb = session.resource('dynamodb')
table = dynamodb.Table('projects')

# Configure CORS
origins = [
    "*", 
    
]

app = FastAPI(title="Project Sharing API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

#health check

@app.get("/health", status_code=status.HTTP_200_OK)
async def health_check():
    return {"message": "Service is healthy"}

# read projects
@app.get("/projects", status_code=status.HTTP_200_OK)
async def get_all_projects(): 
    try:
        response = table.scan()
        projects = response['Items']
        while 'LastEvaluatedKey' in response:
            response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
            projects.extend(response['Items'])
        projects_list = [Project(**project) for project in projects]
        return projects_list
    except Exception as e:
        return {"message": f"Error retrieving projects: {e}"}


#create project
@app.post("/projects", status_code=status.HTTP_200_OK)
async def create_project(project: Project):
    try:
        table.put_item( Item={
            'id': str(uuid.uuid4()),
            'title': project.title,
            'steps':  [steps.dict() for steps in project.steps]
            }
            )
        return {"message": "Project created successfully"}
    except Exception as e:
        return {"message": f"Error creating project: {e}"}



#delete project
@app.delete("/projects/{project_id}", status_code=status.HTTP_200_OK)
async def delete_project(project_id: str):
    try:
        response = table.delete_item(
            Key={
                'id': project_id
            }
        )
        return {"message":response}
    except Exception as e:
        return {"message": f"Error deleting project: {e}"}
