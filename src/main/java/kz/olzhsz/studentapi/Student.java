package kz.olzhsz.studentapi;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "students")
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String fullName;

    @Column(nullable = false, length = 30)
    private String groupName;

    @Column(nullable = false, length = 254)
    private String email;

    protected Student() { }

    public Student(StudentRequest request) {
        updateFrom(request);
    }

    public void updateFrom(StudentRequest request) {
        this.fullName = request.fullName().trim();
        this.groupName = request.groupName().trim();
        this.email = request.email().trim();
    }

    public Long getId() { return id; }
    public String getFullName() { return fullName; }
    public String getGroupName() { return groupName; }
    public String getEmail() { return email; }
}
