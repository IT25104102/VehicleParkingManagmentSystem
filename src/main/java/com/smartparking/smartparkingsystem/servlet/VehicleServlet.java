package com.smartparking.smartparkingsystem.servlet;

import com.smartparking.smartparkingsystem.model.Vehicle;
import com.smartparking.smartparkingsystem.service.VehicleService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/vehicle/*")
public class VehicleServlet extends HttpServlet {

    private final VehicleService vehicleService = new VehicleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":    showList(request, response);     break;
            case "add":     showAddForm(request, response);  break;
            case "edit":    showEditForm(request, response); break;
            case "delete":  deleteVehicle(request, response);break;
            default:        showList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":  addVehicle(request, response);    break;
            case "edit": updateVehicle(request, response); break;
            default:
                response.sendRedirect(request.getContextPath() + "/vehicle/?action=list");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        List<Vehicle> vehicles;

        if (search != null && !search.trim().isEmpty()) {
            vehicles = vehicleService.searchVehicles(search);
            request.setAttribute("search", search);
        } else {
            vehicles = vehicleService.getAllVehicles();
        }

        request.setAttribute("vehicles", vehicles);
        request.getRequestDispatcher("/WEB-INF/views/vehicle/vehicle-list.jsp")
                .forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/vehicle/add-vehicle.jsp")
                .forward(request, response);
    }

    private void addVehicle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Vehicle vehicle = new Vehicle();
        vehicle.setOwnerName(request.getParameter("ownerName"));
        vehicle.setLicensePlate(request.getParameter("licensePlate"));
        vehicle.setVehicleType(request.getParameter("vehicleType"));
        vehicle.setContactNumber(request.getParameter("contactNumber"));
        vehicle.setStatus(request.getParameter("status"));
        vehicleService.addVehicle(vehicle);
        response.sendRedirect(request.getContextPath() + "/vehicle/?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vehicleId = request.getParameter("id");
        Vehicle vehicle  = vehicleService.getVehicleById(vehicleId);
        if (vehicle == null) {
            response.sendRedirect(request.getContextPath() + "/vehicle/?action=list");
            return;
        }
        request.setAttribute("vehicle", vehicle);
        request.getRequestDispatcher("/WEB-INF/views/vehicle/edit-vehicle.jsp")
                .forward(request, response);
    }

    private void updateVehicle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Vehicle vehicle = new Vehicle();
        vehicle.setVehicleId(request.getParameter("vehicleId"));
        vehicle.setOwnerName(request.getParameter("ownerName"));
        vehicle.setLicensePlate(request.getParameter("licensePlate"));
        vehicle.setVehicleType(request.getParameter("vehicleType"));
        vehicle.setContactNumber(request.getParameter("contactNumber"));
        vehicle.setStatus(request.getParameter("status"));
        vehicleService.updateVehicle(vehicle);
        response.sendRedirect(request.getContextPath() + "/vehicle/?action=list");
    }

    private void deleteVehicle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String vehicleId = request.getParameter("id");
        vehicleService.deleteVehicle(vehicleId);
        response.sendRedirect(request.getContextPath() + "/vehicle/?action=list");
    }
}
