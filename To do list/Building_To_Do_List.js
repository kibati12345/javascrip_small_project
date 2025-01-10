document.getElementById("addTaskButton").addEventListener("click", function() {
    const taskInput = document.getElementById("taskInput");
    const taskText = taskInput.value;
  
    if (taskText === "") {
      alert("Please enter a task!");
      return;
    }
  
    const taskList = document.getElementById("taskList");
  
    // Create a new task item
    const taskItem = document.createElement("li");
    taskItem.textContent = taskText;
  
    // Add click event to mark as completed
      taskItem.addEventListener("click", function() {
      taskItem.classList.toggle("completed");
    });
  
    // Add a delete button
    const deleteButton = document.createElement("button");
    deleteButton.textContent = "Delete";
    deleteButton.addEventListener("click", function() {
      taskList.removeChild(taskItem);
    });
  
    taskItem.appendChild(deleteButton);
    taskList.appendChild(taskItem);
  
    // Clear the input box
    taskInput.value = "";
  });
  