import ProjectContent from "../../components/ProjectContent/ProjectContent";

function AdminPage() {
  return (
    <div>
      <ProjectContent isAdmin={true} />
    </div>
  );
}

export default AdminPage;
